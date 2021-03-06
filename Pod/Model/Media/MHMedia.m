//
//  MHMedia.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMedia.h"
#import "MHSource.h"
#import "MHContributor.h"
#import "MHFetcher.h"
#import "MHRelationalPair.h"
#import "MHContext.h"
#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"
#import "MHObject+Internal.h"
#import "MHMetadata.h"
#import "MHSourceMedium+Internal.h"
#import "MHObject+Internal.h"

#import <AtSugar/AtSugar.h>

static NSString* const kRelatedSubendpoint = @"related";
static NSString* const kContentSubendpoint = @"content";
static NSString* const kContributorsSubendpoint = @"contributors";
static NSString* const kSourcesSubendpoint = @"sources";

static NSString* const kRelatedRootSubendpoint = @"related";


@implementation MHMedia

@dynamic metadata;

@declare_class_property (rootEndpoint, @"graph/media")

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(keyContributors))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(primaryGroup))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

+ (NSString*)protocolForArrayProperty:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(keyContributors))]) {
        return NSStringFromClass(MHRelationalPair.class);
    }
    return [super protocolForArrayProperty:propertyName];
}

@end


@implementation MHMedia (Fetching)

- (AnyPromise*)fetchPrimaryGroup
{
    return [self fetchPrimaryGroupForced:NO
                                priority:nil
                            networkToken:nil];
}

- (AnyPromise*)fetchPrimaryGroupForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:NSStringFromSelector(@selector(primaryGroup))
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (AnyPromise*)fetchKeyContributors
{
    return [self fetchKeyContributorsForced:NO
                                   priority:nil
                               networkToken:nil];
}

- (AnyPromise*)fetchKeyContributorsForced:(BOOL)forced
                                 priority:(AVENetworkPriority*)priority
                             networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:NSStringFromSelector(@selector(keyContributors))
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (AnyPromise*)fetchSources
{
    return [self fetchSourcesForced:NO
                           priority:nil
                       networkToken:nil];
}

- (AnyPromise*)fetchSourcesForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kSourcesSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil
                          afterEach:^(MHPagedResponse* response) {
                              for (MHRelationalPair* pair in response.content) {
                                  MHSource* source = (MHSource*)pair.object;
                                  for (MHSourceMedium* medium in pair.context.allMediums) {
                                      medium.source = source;
                                      medium.content = self;
                                  }
                              }
                          }];
}

- (AnyPromise*)fetchRelated
{
    return [self fetchRelatedForced:NO
                           priority:nil
                       networkToken:nil];
}

- (AnyPromise*)fetchRelatedForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kRelatedSubendpoint]
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

- (AnyPromise*)fetchContributors
{
    return [self fetchContributorsForced:NO
                                priority:nil
                            networkToken:nil];
}

- (AnyPromise*)fetchContributorsForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kContributorsSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (AnyPromise*)fetchIVATrailer
{
    return [self fetchIVATrailerForced:NO
                              priority:nil
                          networkToken:nil];
}

- (AnyPromise*)fetchIVATrailerForced:(BOOL)forced
                            priority:(AVENetworkPriority*)priority
                        networkToken:(AVENetworkToken*)networkToken
{
    // Hop off the main thread right away
    return dispatch_promise(^id {
        NSString* path = [self subendpoint:@"ivaTrailer"];
        
        id cachedResponse = [self cachedResponseForPath:path];
        if (!forced && cachedResponse) {
            return [AnyPromise promiseWithValue:cachedResponse];
        }
        
        return [[AVENetworkManager sharedManager] GET:path
                                           parameters:nil
                                             priority:priority
                                         networkToken:networkToken
                                              builder:[MHFetcher sharedFetcher].builder].then(^(id response) {
            if (response) {
                [self setCachedResponse:response forPath:path];
            }
            return response;
        });
    });
}

+ (AnyPromise*)fetchRelatedTo:(NSArray*)medias
{
    return [self fetchRelatedTo:medias
                        filters:nil];
}

+ (AnyPromise*)fetchRelatedTo:(NSArray*)medias
                      filters:(NSDictionary*)filters
{
    return [self fetchRelatedTo:medias
                        filters:filters
                         forced:NO
                       priority:nil
                   networkToken:nil];
}

+ (AnyPromise*)fetchRelatedTo:(NSArray*)medias
                      filters:(nullable NSDictionary*)filters
                       forced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken
{
    NSMutableSet* mhids = [NSMutableSet set];
    for (MHMedia* media in medias) {
        [mhids addObject:media.metadata.mhid];
    }
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"ids"] = mhids;
    if (filters) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:filters
                                                       options:0
                                                         error:nil];
        parameters[@"filters"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return [self fetchRootPagedEndpoint:[self rootSubendpoint:kRelatedRootSubendpoint]
                                 forced:forced
                             parameters:parameters
                               priority:priority
                           networkToken:networkToken
                                   next:nil];
}

@end
