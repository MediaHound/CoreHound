//
//  MHMedia.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHObject.h"
#import "MHRelationalPair.h"



/**
 * A base class which encapsulates common properties of content.
 */
@interface MHMedia : MHObject

@property (strong, atomic) MHMediaMetadata* metadata;

@property (strong, nonatomic) NSArray<MHRelationalPair, Optional>* keyContributors;

/**
 * A relational pair to the MHObject the receiver belongs to.
 * For example, an MHSong's `primaryGroup` will be the primary MHAlbum its on.
 * This property exists on MHSong, MHTvSeason, MHTvEpisode.
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchSocial to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, nonatomic) MHRelationalPair<Optional>* primaryGroup;

@end


@interface MHMedia (Fetching)

- (PMKPromise*)fetchPrimaryGroup;
- (PMKPromise*)fetchPrimaryGroupForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

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
