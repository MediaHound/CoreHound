//
//  MHMedia.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"
#import "MHRelationalPair.h"



/**
 * A base class which encapsulates common properties of content.
 */
@interface MHMedia : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHMediaMetadata* metadata;

/**
 * An array of relational pairs to the key contributors for this media.
 * For example, an MHMovie's `keyContributors` will be the director, lead actors, etc.
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchKeyContributors to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, atomic) NSArray<MHRelationalPair, Optional>* keyContributors;

/**
 * A relational pair to the MHObject the receiver belongs to.
 * For example, an MHSong's `primaryGroup` will be the primary MHAlbum its on.
 * This property exists on MHSong, MHTvSeason, MHTvEpisode.
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchPrimaryGroup to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, atomic) MHRelationalPair<Optional>* primaryGroup;

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

+ (PMKPromise*)fetchRelatedTo:(NSArray*)medias;
+ (PMKPromise*)fetchRelatedTo:(NSArray*)medias
                       forced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken;

@end
