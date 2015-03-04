//
//  MHMedia.h
//  MediaHound
//
//  Created by Tai Bo on 9/10/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHObject.h"
#import "MHRelationalPair.h"



/**
 * A base class which encapsulates common properties of content.
 */
@interface MHMedia : MHObject

@property (strong, atomic) MHMediaMetadata* metadata;

@property (strong, nonatomic) NSArray<MHRelationalPair, Optional>* keyContributors;

@property (strong, nonatomic) MHRelationalPair<Optional>* primaryGroup;

@end


@interface MHMedia (Fetching)

- (PMKPromise*)fetchKeyContributors;
- (PMKPromise*)fetchKeyContributorsForced:(BOOL)forced
                                 priority:(AVENetworkPriority*)priority
                             networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchSources;
- (PMKPromise*)fetchSourcesForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchRelated;
- (PMKPromise*)fetchRelatedForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchContent;
- (PMKPromise*)fetchContentForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchContributors;
- (PMKPromise*)fetchContributorsForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

@end
