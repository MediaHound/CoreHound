//
//  MHObject.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <Avenue/Avenue.h>
#import <PromiseKit/PromiseKit.h>
#import "MHMetadata.h"

@class MHImage;
@class MHSocial;
@class MHRelationalPair;


/**
 * The base model for a MediaHound entity.
 * All KVO notifications for MHObjects occur on background threads.
 * You must dispatch to the main thread to update UI based on MediaHound KVO notifications.
 */
@interface MHObject : JSONModel

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHMetadata* metadata;

/**
 * The primary image is the receiver's primary visual representation
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchPrimaryImage to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, atomic) MHImage<Optional>* primaryImage;

/**
 * The secondary image is the receiver's secondary visual representation
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchSecondaryImage to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, atomic) MHImage<Optional>* secondaryImage;

/**
 * Social metrics and user-specific information about the receiver
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchSocial to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, nonatomic) MHSocial<Optional>* social;

/**
 * @param mhid The mhid to check for
 * @return the Objective-C class that maps to a given mhid.
 */
+ (Class)classForMhid:(NSString*)mhid;

/**
 * @param The MHObject to check for
 * @return Whether the receiver is equivalent to the given MHObject.
 */
- (BOOL)isEqualToMHObject:(MHObject*)object;

/**
 * @param mhid The mhid to check for
 * @return Whether the receiver has the given mhid.
 */
- (BOOL)hasMhid:(NSString*)mhid;

/**
 * Mark the receiver as `liked` by the current user.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (PMKPromise*)like;

/**
 * Undoes a `like` action on the receiver.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (PMKPromise*)unlike;

/**
 * Mark the receiver as `followed` by the current user.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (PMKPromise*)follow;
/**
 * Undoes a `follow` action on the receiver.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (PMKPromise*)unfollow;

@end


@interface MHObject (Fetching)

/**
 * Fetches an MHObject by its mhid.
 * MHObjects are cached, so a request for an already fetched mhid will not require a network request.
 * @param mhid The identifier for the MHObject
 * @return A promise which resolves with the MHObject.
 */
+ (PMKPromise*)fetchByMhid:(NSString*)mhid;

/**
 * Fetches an MHObject by its mhid.
 * MHObjects are cached, so a request for an already fetched mhid will not require a network request.
 * @param mhid The identifier for the MHObject
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with the MHObject.
 */
+ (PMKPromise*)fetchByMhid:(NSString*)mhid
                  priority:(AVENetworkPriority*)priority
              networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches the receiver's social metrics.
 * You should never read the `social` property directly from an MHObject. Instead, always access social metrics via
 * the `fetchSocial` promise. The `social` property can be used for observing KVO changes to social metrics.
 * @return A promise whcih resolves with an MHSocial.
 */
- (PMKPromise*)fetchSocial;

/**
 * Fetches the receiver's social metrics.
 * You should never read the `social` property directly from an MHObject. Instead, always access social metrics via
 * the `fetchSocial` promise. The `social` property can be used for observing KVO changes to social metrics.
 * @param forced Whether to use a cached response. If NO, a network request will occur.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise whcih resolves with an MHSocial.
 */
- (PMKPromise*)fetchSocialForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchPrimaryImage;
- (PMKPromise*)fetchPrimaryImageForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchSecondaryImage;
- (PMKPromise*)fetchSecondaryImageForced:(BOOL)forced
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches the activity feed for the receiver.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchFeed;

/**
 * Fetches the activity feed for the receiver.
 * @param forced Whether to use a cached response. If NO, a network request will occur.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchFeedForced:(BOOL)forced
                      priority:(AVENetworkPriority*)priority
                  networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all collections that contain the receiver.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchCollections;

/**
 * Fetches all collections that contain the receiver.
 * @param forced Whether to use a cached response. If NO, a network request will occur.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchCollectionsForced:(BOOL)forced
                             priority:(AVENetworkPriority*)priority
                         networkToken:(AVENetworkToken*)networkToken;

@end
