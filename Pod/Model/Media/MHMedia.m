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

@end


@implementation MHMedia (Fetching)

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
    return [self fetchProperty:NSStringFromSelector(@selector(primaryGroup))
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (PMKPromise*)fetchKeyContributors
{
    return [self fetchKeyContributorsForced:NO
                                   priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                               networkToken:nil];
}

- (PMKPromise*)fetchKeyContributorsForced:(BOOL)forced
                                 priority:(AVENetworkPriority*)priority
                             networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchProperty:NSStringFromSelector(@selector(keyContributors))
                        forced:forced
                      priority:priority
                  networkToken:networkToken];
}

- (PMKPromise*)fetchSources
{
    return [self fetchSourcesForced:NO
                           priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                       networkToken:nil];
}

- (PMKPromise*)fetchSourcesForced:(BOOL)forced
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

- (PMKPromise*)fetchRelated
{
    return [self fetchRelatedForced:NO
                           priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                       networkToken:nil];
}

- (PMKPromise*)fetchRelatedForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kRelatedSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (PMKPromise*)fetchContent
{
    return [self fetchContentForced:NO
                           priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                       networkToken:nil];
}

- (PMKPromise*)fetchContentForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kContentSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (PMKPromise*)fetchContributors
{
    return [self fetchContributorsForced:NO
                                priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                            networkToken:nil];
}

- (PMKPromise*)fetchContributorsForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kContributorsSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

+ (PMKPromise*)fetchRelatedTo:(NSArray*)medias
{
    return [self fetchRelatedTo:medias
                         forced:NO
                       priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                   networkToken:nil];
}

+ (PMKPromise*)fetchRelatedTo:(NSArray*)medias
                       forced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken
{
    NSMutableSet* mhids = [NSMutableSet set];
    for (MHMedia* media in medias) {
        [mhids addObject:media.metadata.mhid];
    }
    
    return [self fetchRootPagedEndpoint:[self rootSubendpoint:kRelatedRootSubendpoint]
                                 forced:forced
                             parameters:@{
                                          @"ids": mhids
                                          }
                               priority:priority
                           networkToken:networkToken
                                   next:nil];
}

@end
