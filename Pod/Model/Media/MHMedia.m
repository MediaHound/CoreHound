//
//  MHMedia.m
//  MediaHound
//
//  Created by Tai Bo on 9/10/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHMedia.h"
#import "MHSource.h"
#import "MHVideoModel.h"
#import "MHContributor.h"
#import "MHFetcher.h"
#import "MHRelationalPair.h"
#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"
#import "MHObject+Internal.h"
#import "MHMetadata.h"
#import "MHSourceMedium+Internal.h"

#import <AtSugar/AtSugar.h>
#import <Avenue/AVENetworkManager.h>


@implementation MHMedia

@declare_class_property (rootEndpoint, @"graph/media")

@end


@implementation MHMedia (Fetching)

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
    if (self.keyContributors && !forced) {
        return [PMKPromise promiseWithValue:self.keyContributors];
    }
    return [self.class fetchFullViewForMhid:self.metadata.mhid
                                   priority:priority
                               networkToken:networkToken].thenInBackground(^(MHMedia* object) {
        return object.keyContributors;
    });
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
    return [self fetchPagedEndpoint:[self subendpoint:@"sources"]
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
    return [self fetchPagedEndpoint:[self subendpoint:@"related"]
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
    return [self fetchPagedEndpoint:[self subendpoint:@"content"]
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
    return [self fetchPagedEndpoint:[self subendpoint:@"contributors"]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

@end
