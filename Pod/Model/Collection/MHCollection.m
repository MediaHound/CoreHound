//
//  MHCollection.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHCollection.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"
#import "MHAction.h"
#import "MHLoginSession.h"
#import "MHUser.h"
#import "MHUser+Internal.h"
#import "MHMetadata.h"
#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"

#import <Avenue/AVENetworkManager.h>

static NSString* const kContentSubendpoint = @"content";
static NSString* const kMixlistSubendpoint = @"mixlist";
static NSString* const kOwnersSubendpoint = @"owners";
static NSString* const kUpdateSubendpoint = @"update";


@implementation MHCollection

@dynamic metadata;

@declare_class_property (mhidPrefix, @"mhcol")
@declare_class_property (rootEndpoint, @"graph/collection")

+ (void)load
{
    [self registerMHObject];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(primaryOwner))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(firstContentImage))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (AnyPromise*)addContent:(MHObject*)content
{
    return [self addContents:@[content]];
}

- (AnyPromise*)addContents:(NSArray*)contents
{
    return [self changeContents:contents modification:@"add"];
}

- (AnyPromise*)removeContent:(MHObject*)content
{
    return [self removeContents:@[content]];
}

- (AnyPromise*)removeContents:(NSArray*)contents
{
    return [self changeContents:contents modification:@"remove"];
}

- (AnyPromise*)changeContents:(NSArray*)contents modification:(NSString*)modification
{
    NSMutableSet* mhids = [NSMutableSet set];
    for (MHObject* content in contents) {
        [mhids addObject:content.metadata.mhid];
    }
    
    return [[AVENetworkManager sharedManager] PUT:[self subendpoint:modification]
                                       parameters:@{
                                                    @"content": mhids
                                                    }
                                         priority:nil
                                     networkToken:nil
                                          builder:[MHFetcher sharedFetcher].builder].thenInBackground(^(id responseObject) {
        [self invalidateContent];
        [self invalidateMixlist];
        
        for (MHObject* content in contents) {
            [content fetchSocialForced:YES
                              priority:nil
                          networkToken:nil];
            [content invalidateCollections];
        }
        
        return responseObject;
    });
}

- (AnyPromise*)setName:(NSString*)name
{
    return [[MHFetcher sharedFetcher] putAndFetchModel:MHCollectionMetadata.class
                                                  path:[self subendpoint:kUpdateSubendpoint]
                                               keyPath:@"metadata"
                                            parameters:@{
                                                         @"name": name
                                                         }].thenInBackground(^(MHCollectionMetadata* metadata) {
        if (![self.metadata isEqual:metadata]) {
            self.metadata = metadata;
        }
        return self;
    });
}

- (void)invalidateContent
{
    [self invalidateCacheForEndpoint:[self subendpoint:kContentSubendpoint]];
    [self fetchContentForced:YES
                    priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelLow]
                networkToken:nil];
}

- (void)invalidateMixlist
{
    [self invalidateCacheForEndpoint:[self subendpoint:kMixlistSubendpoint]];
    [self fetchMixListForced:YES
                    priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelLow]
                networkToken:nil];
}

@end


@implementation MHCollection (Creating)

+ (AnyPromise*)createWithName:(NSString*)name
{
    return [self createWithName:name initialContent:nil];
}

+ (AnyPromise*)createWithName:(NSString*)name initialContent:(NSArray*)initialContent
{
    NSAssert(name, @"When creating a collection, you must provide a name.");
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = name;
    if (initialContent) {
        NSMutableSet* mhids = [NSMutableSet set];
        for (MHObject* content in initialContent) {
            [mhids addObject:content.metadata.mhid];
        }
        parameters[@"content"] = mhids;
    }
    
    return [[MHFetcher sharedFetcher] postAndFetchModel:MHCollection.class
                                                   path:[self rootSubendpoint:kCreateRootSubendpoint]
                                                keyPath:nil
                                             parameters:parameters].thenInBackground(^(MHCollection* collection) {
        MHUser* currentUser = [MHLoginSession currentSession].user;
        
        [currentUser fetchSocialForced:YES
                              priority:nil
                          networkToken:nil];
        
        [currentUser invalidateOwnedCollections];
        
        return collection;
    });
}

@end


@implementation MHCollection (Fetching)

- (AnyPromise*)fetchPrimaryOwner
{
    return [self fetchPrimaryOwnerForced:NO
                                priority:nil
                            networkToken:nil];
}

- (AnyPromise*)fetchPrimaryOwnerForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:NSStringFromSelector(@selector(primaryOwner))
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (AnyPromise*)fetchFirstContentImage
{
    return [self fetchFirstContentImageForced:NO
                                     priority:nil
                                 networkToken:nil];
}

- (AnyPromise*)fetchFirstContentImageForced:(BOOL)forced
                                   priority:(AVENetworkPriority*)priority
                               networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:NSStringFromSelector(@selector(firstContentImage))
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (AnyPromise*)fetchOwners
{
    return [self fetchOwnersForced:NO
                          priority:nil
                      networkToken:nil];
}

- (AnyPromise*)fetchOwnersForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kOwnersSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (AnyPromise*)fetchContent
{
    return [self fetchContentForced:NO
                           priority:nil
                       networkToken:nil];
}

- (AnyPromise*)fetchContentForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kContentSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (AnyPromise*)fetchMixList
{
    return [self fetchMixListForced:NO
                           priority:nil
                       networkToken:nil];
}

- (AnyPromise*)fetchMixListForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kMixlistSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

@end
