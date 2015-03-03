//
//  MHObject.m
//  MediaHound
//
//  Created by Tai Bo on 11/29/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHObject.h"
#import "MHObject+Internal.h"
#import "MHMedia.h"
#import "MHSocial.h"
#import "MHAction.h"
#import "MHFetcher.h"
#import "MHLoginSession.h"
#import "MHUser.h"
#import "MHUser+Internal.h"
#import "MHCollection.h"
#import "MHMetadata.h"
#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"

#import <Avenue/AVENetworkManager.h>
#import <AgnosticLogger/AgnosticLogger.h>

const NSInteger MHInternal_DefaultPageSize = 12;

NSString* const MHFetchParameterView = @"view";
NSString* const MHFetchParameterViewFull = @"full";

static NSString* const kCollectionsSubendpoint = @"collections";


@interface MHObjectTable : NSObject

+ (instancetype)sharedTable;

/// An in-memory cache from mhid -> MHObjects.
@property (strong, nonatomic) NSMutableDictionary* mhidTable;

/// A lock to synchronize access to `mhidTable`.
@property (strong, nonatomic) NSLock* tableLock;

@end


@implementation MHObjectTable

@singleton (sharedTable)

- (instancetype)init
{
    if (self = [super init]) {
        _mhidTable = [[NSMutableDictionary alloc] init];
        _tableLock = [[NSLock alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidLogout:)
                                                     name:MHLoginSessionUserDidLogoutNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)userDidLogout:(NSNotification*)notification
{
    [self.tableLock lock];
    
    // Forcibly clear the mhid table when the user logs out so we clear all the social objects
    [self.mhidTable removeAllObjects];
    
    [self.tableLock unlock];
}

@end


@interface MHObject ()

@property (atomic) NSNumber<Ignore>* mostRecentSocialRequestId;

@property (strong, nonatomic) NSMutableDictionary<Ignore>* cachedResponses;

@end


@implementation MHObject

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    // This method should always be called off the main thread
    // We do lots of locking and heavy parsing.
    NSAssert(![NSThread isMainThread], @"MHObject -initWithDictionary:error: is called from the main thread.");
    
    // Check if this MHObject is already in the MHObject table.
    NSString* mhid = dict[@"metadata"][@"mhid"];
    
    NSMutableDictionary* mhidTable = [[MHObjectTable sharedTable] mhidTable];
    NSLock* tableLock = [[MHObjectTable sharedTable] tableLock];
    

    // Check if the mhid is already in the mhidTable
    [tableLock lock];
    MHObject* tableValue = [mhidTable objectForKey:mhid];
    [tableLock unlock];
    
    if (tableValue) {
        // The mhid object or a promised fetch was found in the table
        self = nil;
        
        // Merge the dict with what was found MHObject in the table.
        [tableValue mergeFromDictionary:dict useKeyMapping:YES];
        
        return tableValue;
    }
    else {
        if (![self isMemberOfClass:MHObject.class]) {
            // If we are not initializing the Abstract MHObject class, then just call through to JSONModel's init
            
            self = [super initWithDictionary:dict error:err];
            self.cachedResponses = [NSMutableDictionary dictionary];
            
            [tableLock lock];
            
            // Check the table again to see if this mhid has been added to the table while we've been
            // building this MHObject
            id tableValueAgain = [mhidTable objectForKey:mhid];
            
            if (tableValueAgain) {
                AGLLogInfo(@"[MHObject] Finished initializing an MHObject, but one was already created in the mhid-table in the meantime. mhid: %@", self.metadata.mhid);
                [tableLock unlock];
                self = nil;
                return tableValueAgain;
            }
            else {
                AGLLogInfo(@"[MHObject] Inserting mhid:%@ into table", mhid);
                [mhidTable setObject:self forKey:mhid];
                [tableLock unlock];
                return self;
            }
        }
        else {
            // Otherwise, we are treating MHObject as a class cluster and want to instantiate
            // a specific type based on the mhid of the data coming in.
            
            Class class = [self.class classForMhid:mhid];
            
            if (!class) {
                [NSException raise:@"Invalid Mhid" format:@"MHObject constructor did not find a class for mhid: %@", mhid];
            }
            self = nil;
            return [[class alloc] initWithDictionary:dict error:err];
        }
    }
}

+ (NSString*)mhidPrefix
{
    // Subclasses should override
    NSAssert(NO, @"Class: `%@` did not override +mhidPrefix", self);
    return nil;
}

+ (Class)classForMhid:(NSString*)mhid
{
    Class modelClass = nil;
    
    NSDictionary* mapping = [self prefixModelMapping];
    
    for (NSString* key in mapping.allKeys) {
        if ([mhid hasPrefix:key]) {
            modelClass = mapping[key];
            break;
        }
    }
    
    return modelClass;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:MHObject.class]) {
        return NO;
    }
    
    return [self isEqualToMHObject:(MHObject*)object];
}

- (BOOL)isEqualToMHObject:(MHObject*)object
{
    if (![object isKindOfClass:MHObject.class]) {
        return NO;
    }
    return [self hasMhid:object.metadata.mhid];
}

- (NSUInteger)hash
{
    return self.metadata.mhid.hash;
}

- (BOOL)hasMhid:(NSString*)mhid
{
    return ([self.metadata.mhid isEqualToString:mhid]);
}

- (PMKPromise*)takeAction:(NSString*)action
               parameters:(NSDictionary*)parameters
     predictedSocialBlock:(MHSocial*(^)(MHSocial*, NSDictionary*))predictedSocialBlock
{
    // Hop off the main thread right away
    return dispatch_promise(^id {
        // We'll store the request Id, so that only the most recent request
        // actually updates self.social, which triggers KVO.
        NSInteger requestId = arc4random();
        self.mostRecentSocialRequestId = @(requestId);
        
        AGLLogInfo(@"[MHObject] Take action `%@` on mhid `%@` with params `%@`", action, self.metadata.mhid, parameters);
        
        // Instantly update social values with our best guess of what will happen.
        if (self.social) {
            // Note: If social has not been fetched, then this won't be executed and we'll have
            //       to wait until the social action request has returned
            self.social = predictedSocialBlock(self.social, parameters);
        }
        
        return [[MHFetcher sharedFetcher] putAndFetchModel:MHSocial.class
                                                      path:[self subendpoint:action]
                                                   keyPath:@"social"
                                                parameters:parameters].thenInBackground(^(MHSocial* social) {
            if (requestId == self.mostRecentSocialRequestId.integerValue) {
                if (![self.social isEqualToSocial:social]) {
                    self.social = social;
                }
            }
            return self.social;
        });
    });
}

- (PMKPromise*)like
{
    return [self takeAction:@"like"
                 parameters:nil
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.likers = @(newSocial.likers.integerValue + 1);
           newSocial.userLikes = @(YES);
           return newSocial;
       }];
}

- (PMKPromise*)unlike
{
    
    return [self takeAction:@"unlike"
                 parameters:nil
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.likers = @(newSocial.likers.integerValue - 1);
           newSocial.userLikes = @(NO);
           return newSocial;
       }];
}

- (PMKPromise*)follow
{
    return [self takeAction:@"follow"
                 parameters:nil
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.followers = @(newSocial.followers.integerValue + 1);
           newSocial.userFollows = @(YES);
           return newSocial;
       }].thenInBackground(^(MHSocial* social) {
           [[MHLoginSession currentSession].user invalidateFollowing];
           return social;
       });
}

- (PMKPromise*)unfollow
{
    return [self takeAction:@"unfollow"
                 parameters:nil
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.followers = @(newSocial.followers.integerValue - 1);
           newSocial.userFollows = @(NO);
           return newSocial;
       }].thenInBackground(^(MHSocial* social) {
           [[MHLoginSession currentSession].user invalidateFollowing];
           return social;
       });
}

@end


@implementation MHObject (Fetching)

+ (PMKPromise*)fetchByMhid:(NSString*)mhid
{
    return [self fetchByMhid:mhid
                    priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                networkToken:nil];
}

+ (PMKPromise*)fetchByMhid:(NSString*)mhid
                  priority:(AVENetworkPriority*)priority
              networkToken:(AVENetworkToken*)networkToken
{
    // Hop off the main thread right away
    return dispatch_promise(^id {
        NSMutableDictionary* mhidTable = [[MHObjectTable sharedTable] mhidTable];
        NSLock* tableLock = [[MHObjectTable sharedTable] tableLock];
        
        // See if the mhid is already in the mhidTable
        [tableLock lock];
        id tableValue = [mhidTable objectForKey:mhid];
        [tableLock unlock];
        
        if (tableValue) {
            // The mhid object was found in the table
            return tableValue;
        }
        else {
            // Nothing found in the cache, go fetch the mhid
            return [self fetchFullViewForMhid:mhid
                                                    priority:priority
                                                networkToken:networkToken];
        }
    });
}

- (PMKPromise*)fetchSocial
{
    return [self fetchSocialForced:NO
                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                      networkToken:nil];
}

- (PMKPromise*)fetchSocialForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(AVENetworkToken*)networkToken
{
    // Hop off the main thread right away
    return dispatch_promise(^id {
        if (!forced) {
            MHSocial* social = self.social;
            if (social) {
                return [PMKPromise promiseWithValue:social];
            }
        }
        return [[MHFetcher sharedFetcher] fetchModel:MHSocial.class
                                                path:[self subendpoint:@"social"]
                                             keyPath:@"social"
                                          parameters:nil
                                            priority:priority
                                        networkToken:networkToken].thenInBackground(^(MHSocial* social) {
            if (![self.social isEqualToSocial:social]) {
                self.social = social;
            }
            return social;
        });
    });
}

- (PMKPromise*)fetchPrimaryImage
{
    return [self fetchPrimaryImageForced:NO
                                priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                            networkToken:nil];
}

- (PMKPromise*)fetchPrimaryImageForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:@"primaryImage"
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (PMKPromise*)fetchPrimaryGroup
{
    return [self fetchPrimaryGroupForced:NO
                                priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                            networkToken:nil];
}

- (PMKPromise*)fetchPrimaryGroupForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:@"primaryGroup"
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (PMKPromise*)fetchSecondaryImage
{
    return [self fetchSecondaryImageForced:NO
                                  priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                              networkToken:nil];
}

- (PMKPromise*)fetchSecondaryImageForced:(BOOL)forced
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:@"secondaryImage"
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (PMKPromise*)fetchFeed
{
    return [self fetchFeedForced:NO
                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                    networkToken:nil];
}

- (PMKPromise*)fetchFeedForced:(BOOL)forced
                      priority:(AVENetworkPriority*)priority
                  networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:@"feed"]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (PMKPromise*)fetchCollections
{
    return [self fetchCollectionsForced:NO
                               priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                           networkToken:nil];
}

- (PMKPromise*)fetchCollectionsForced:(BOOL)forced
                             priority:(AVENetworkPriority*)priority
                         networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kCollectionsSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

@end


@implementation MHObject (Internal)

#pragma mark - Fetching

+ (PMKPromise*)fetchFullViewForMhid:(NSString*)mhid
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken
{
    Class modelClass = [self classForMhid:mhid];
    NSString* path = [modelClass endpointForMhid:mhid];
    
    return [[MHFetcher sharedFetcher] fetchModel:modelClass
                                            path:path
                                         keyPath:nil
                                      parameters:@{
                                                   MHFetchParameterView: MHFetchParameterViewFull
                                                   }
                                        priority:priority
                                    networkToken:networkToken];
    
}

- (NSString*)responseCacheKeyForPath:(NSString*)path
{
    return [NSString stringWithFormat:@"__cached_%@", path];
}

- (MHPagedResponse*)cachedResponseForPath:(NSString*)path
{
    NSString* cacheKey = [self responseCacheKeyForPath:path];
    @synchronized (self) {
        return self.cachedResponses[cacheKey];
    }
}

- (void)setCachedResponse:(MHPagedResponse*)response forPath:(NSString*)path
{
    NSString* cacheKey = [self responseCacheKeyForPath:path];
    @synchronized (self) {
        self.cachedResponses[cacheKey] = response;
    }
}

- (void)invalidateCacheForEndpoint:(NSString*)path
{
    NSString* cacheKey = [self responseCacheKeyForPath:path];
    @synchronized (self) {
        [self.cachedResponses removeObjectForKey:cacheKey];
    }
}

- (void)invalidateCollections
{
    [self invalidateCacheForEndpoint:[self subendpoint:kCollectionsSubendpoint]];
    [self fetchCollectionsForced:YES
                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelLow]
                    networkToken:nil];
}

- (PMKPromise*)fetchPagedEndpoint:(NSString*)path
                           forced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
                             next:(NSString*)next
{
    return [self fetchPagedEndpoint:path
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:next
                          afterEach:nil];
}

- (PMKPromise*)fetchPagedEndpoint:(NSString*)path
                           forced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
                             next:(NSString*)next
                        afterEach:(void(^)(MHPagedResponse*))afterEach
{
    @weakSelf()
    
    // Hop off the main thread right away
    return dispatch_promise(^id {
        if (!next && !forced) {
            MHPagedResponse* cachedResponse = [self cachedResponseForPath:path];
            if (cachedResponse) {
                return [PMKPromise promiseWithValue:cachedResponse];
            }
        }
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        parameters[@"pageSize"] = @(MHInternal_DefaultPageSize);
        parameters[MHFetchParameterView] = MHFetchParameterViewFull;
        if (next) {
            parameters[@"pageNext"] = next;
            parameters[@"next"] = next;
        }
        
        return [[MHFetcher sharedFetcher] fetchModel:MHPagedResponse.class
                                                path:path
                                             keyPath:nil
                                          parameters:parameters
                                            priority:priority
                                        networkToken:networkToken].thenInBackground(^(MHPagedResponse* pagedResponse) {
            if (afterEach) {
                afterEach(pagedResponse);
            }
            
            pagedResponse.fetchNextOperation = ^(NSString* newNext) {
                return [weakSelf fetchPagedEndpoint:path
                                             forced:NO
                                           priority:priority
                                       networkToken:nil
                                               next:newNext];
            };
            
            if (!next) {
                [self setCachedResponse:pagedResponse forPath:path];
            }
            
            return pagedResponse;
        });
    });
}

- (PMKPromise*)fetchProperty:(NSString*)property
                      forced:(BOOL)forced
                    priority:(AVENetworkPriority*)priority
                networkToken:(AVENetworkToken*)networkToken
{
    // Note: the property should be marked `atomic`.
    
    // Hop of the main thread right away
    return dispatch_promise(^id {
        if (!forced) {
            id value = [self valueForKey:property];
            if (value) {
                return [PMKPromise promiseWithValue:value];
            }
        }
        return [self.class fetchFullViewForMhid:self.metadata.mhid
                                       priority:priority
                                   networkToken:networkToken].thenInBackground(^(MHObject* object) {
            return [object valueForKey:property];
        });
    });
}

#pragma mark - Endpoints

+ (NSString*)rootEndpoint
{
    // Subclasses should override
    NSAssert(NO, @"Class: `%@` did not override +rootEndpoint", self);
    return nil;
}

+ (NSString*)endpointForMhid:(NSString*)mhid
{
    // Note: If invoked via a subclass of MHObject, this method
    //       does not ensure the mhid belongs to that subclass.
    
    NSString* rootEndpoint = [self rootEndpoint];
    if (!rootEndpoint) {
        // Supports invoking [MHObject endpointForMhid:mhid]
        id modelClass = [self classForMhid:mhid];
        rootEndpoint = [modelClass rootEndpoint];
    }
    return [NSString stringWithFormat:@"%@/%@", rootEndpoint, mhid];
}

- (NSString*)endpoint
{
    return [self.class endpointForMhid:self.metadata.mhid];
}

- (NSString*)subendpoint:(NSString*)sub
{
    return [NSString stringWithFormat:@"%@/%@", self.endpoint, sub];
}

+ (NSString*)rootSubendpoint:(NSString*)sub
{
    return [NSString stringWithFormat:@"%@/%@", [self rootEndpoint], sub];
}

#pragma mark - MHObject Registration

static NSMutableDictionary* s_prefixModelMapping = nil;

+ (void)registerMHObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_prefixModelMapping = [NSMutableDictionary dictionary];
    });
    
    s_prefixModelMapping[[[self class] mhidPrefix]] = [self class];
}

+ (NSArray*)registeredMHObjects
{
    return [s_prefixModelMapping allValues];
}

+ (NSDictionary*)prefixModelMapping
{
    return s_prefixModelMapping;
}

@end
