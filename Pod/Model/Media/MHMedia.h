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
 * This property exists on MHSong, MHShowSeason, MHShowEpisode.
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchPrimaryGroup to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, atomic) MHRelationalPair<Optional>* primaryGroup;

@end


@interface MHMedia (Fetching)

/**
 * Fetches the media's primary group.
 * For example, an MHSong's `primaryGroup` will be the primary MHAlbum its on.
 * This method is valid on MHSong, MHShowSeason, MHShowEpisode.
 * You should never read the `primaryGroup` property directly from an MHMedia. Instead, always access the group via
 * the `fetchPrimaryGroup` promise. The `primaryGroup` property can be used for observing KVO changes to primary group.
 * @return A promise which resolves with an MHRelationalPair.
 */
- (PMKPromise*)fetchPrimaryGroup;

/**
 * Fetches the media's primary group.
 * For example, an MHSong's `primaryGroup` will be the primary MHAlbum its on.
 * This method is valid on MHSong, MHShowSeason, MHShowEpisode.
 * You should never read the `primaryGroup` property directly from an MHMedia. Instead, always access the group via
 * the `fetchPrimaryGroup` promise. The `primaryGroup` property can be used for observing KVO changes to primary group.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHRelationalPair.
 */
- (PMKPromise*)fetchPrimaryGroupForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches the media's key contributors.
 * You should never read the `keyContributors` property directly from an MHMedia. Instead, always access the contributors via
 * the `fetchKeyContributors` promise. The `keyContributors` property can be used for observing KVO changes to key contributors.
 * @return A promise which resolves with an NSArray of MHRelationalPairs.
 */
- (PMKPromise*)fetchKeyContributors;

/**
 * Fetches the media's key contributors.
 * You should never read the `keyContributors` property directly from an MHMedia. Instead, always access the contributors via
 * the `fetchKeyContributors` promise. The `keyContributors` property can be used for observing KVO changes to key contributors.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an NSArray of MHRelationalPairs.
 */
- (PMKPromise*)fetchKeyContributorsForced:(BOOL)forced
                                 priority:(AVENetworkPriority*)priority
                             networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches sources for this media.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchSources;

/**
 * Fetches sources for this media.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchSourcesForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches related content similar to this MHMedia.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchRelated;

/**
 * Fetches related content similar to this MHMedia.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchRelatedForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all contained content that this media is parent to.
 * For example, calling `-fetchContent` on a MHShowSeason gives all MHShowEpisodes in that season.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchContent;

/**
 * Fetches all contained content that this media is parent to.
 * For example, calling `-fetchContent` on a MHShowSeason gives all MHShowEpisodes in that season.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchContentForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all contributors who have contributed to this media.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchContributors;

/**
 * Fetches all contributors who have contributed to this media.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchContributorsForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches content that is related to the given array of media.
 * @param medias An array of media to find related content to.
 * @return A promise which resolves with an MHPagedResponse.
 */
+ (PMKPromise*)fetchRelatedTo:(NSArray*)medias;

/**
 * Fetches content that is related to the given array of media.
 * @param medias An array of media to find related content to.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
+ (PMKPromise*)fetchRelatedTo:(NSArray*)medias
                       forced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken;

@end
