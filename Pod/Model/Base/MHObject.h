//
//  MHObject.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <Avenue/Avenue.h>
#import <PromiseKit/PromiseKit.h>

#import "MHMetadata.h"

@class MHImage;
@class MHSocial;

NS_ASSUME_NONNULL_BEGIN


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
@property (strong, nullable, atomic) MHImage* primaryImage;

/**
 * The secondary image is the receiver's secondary visual representation
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchSecondaryImage to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, nullable, atomic) MHImage* secondaryImage;

/**
 * Social metrics and user-specific information about the receiver
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchSocial to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, nullable, nonatomic) MHSocial* social;

/**
 * @param mhid The mhid to check for
 * @return the Objective-C class that maps to a given mhid.
 */
+ (Class)classForMhid:(NSString*)mhid;

/**
 * @param object The MHObject to check for
 * @return Whether the receiver is equivalent to the given MHObject.
 */
- (BOOL)isEqualToMHObject:(MHObject*)object;

/**
 * @param mhid The mhid to check for
 * @return Whether the receiver has the given mhid.
 */
- (BOOL)hasMhid:(NSString*)mhid;

@end


@interface MHObject (Actions)

/**
 * Mark the receiver as `liked` by the current user.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (AnyPromise*)like;

/**
 * Undoes a `like` action on the receiver.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (AnyPromise*)unlike;

/**
 * Mark the receiver as `followed` by the current user.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (AnyPromise*)follow;
/**
 * Undoes a `follow` action on the receiver.
 * The returned promise resolves when the request has completed.
 * The returned promise resolves to an updated MHSocial.
 * The receiver's social property will be updated before the promise resolves.
 */
- (AnyPromise*)unfollow;

@end


@interface MHObject (Fetching)

/**
 * Fetches an MHObject by its mhid.
 * MHObjects are cached, so a request for an already fetched mhid will not require a network request.
 * @param mhid The identifier for the MHObject
 * @return A promise which resolves with the MHObject.
 */
+ (AnyPromise*)fetchByMhid:(NSString*)mhid;

/**
 * Fetches an MHObject by its mhid.
 * MHObjects are cached, so a request for an already fetched mhid will not require a network request.
 * @param mhid The identifier for the MHObject
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with the MHObject.
 */
+ (AnyPromise*)fetchByMhid:(NSString*)mhid
                  priority:(AVENetworkPriority*)priority
              networkToken:(nullable AVENetworkToken*)networkToken;

/**
 * Fetches the receiver's social metrics.
 * You should never read the `social` property directly from an MHObject. Instead, always access social metrics via
 * the `fetchSocial` promise. The `social` property can be used for observing KVO changes to social metrics.
 * @return A promise whcih resolves with an MHSocial.
 */
- (AnyPromise*)fetchSocial;

/**
 * Fetches the receiver's social metrics.
 * You should never read the `social` property directly from an MHObject. Instead, always access social metrics via
 * the `fetchSocial` promise. The `social` property can be used for observing KVO changes to social metrics.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise whcih resolves with an MHSocial.
 */
- (AnyPromise*)fetchSocialForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(nullable AVENetworkToken*)networkToken;

/**
 * Fetches the receiver's primary image.
 * You should never read the `primaryImage` property directly from an MHObject. Instead, always access the image via
 * the `fetchPrimaryImage` promise. The `primaryImage` property can be used for observing KVO changes to primary image.
 * @return A promise which resolves with an MHImage.
 */
- (AnyPromise*)fetchPrimaryImage;

/**
 * Fetches the receiver's primary image.
 * You should never read the `primaryImage` property directly from an MHObject. Instead, always access the image via
 * the `fetchPrimaryImage` promise. The `primaryImage` property can be used for observing KVO changes to primary image.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHImage.
 */
- (AnyPromise*)fetchPrimaryImageForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(nullable AVENetworkToken*)networkToken;

/**
 * Fetches the receiver's secondary image.
 * You should never read the `secondaryImage` property directly from an MHObject. Instead, always access the image via
 * the `fetchSecondaryImage` promise. The `secondaryImage` property can be used for observing KVO changes to secondary image.
 * @return A promise which resolves with an MHImage.
 */
- (AnyPromise*)fetchSecondaryImage;

/**
 * Fetches the receiver's secondary image.
 * You should never read the `secondaryImage` property directly from an MHObject. Instead, always access the image via
 * the `fetchSecondaryImage` promise. The `secondaryImage` property can be used for observing KVO changes to secondary image.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHImage.
 */
- (AnyPromise*)fetchSecondaryImageForced:(BOOL)forced
                                priority:(AVENetworkPriority*)priority
                            networkToken:(nullable AVENetworkToken*)networkToken;

/**
 * Fetches the activity feed for the receiver.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchFeed;

/**
 * Fetches the activity feed for the receiver.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchFeedForced:(BOOL)forced
                      priority:(AVENetworkPriority*)priority
                  networkToken:(nullable AVENetworkToken*)networkToken;

/**
 * Fetches all collections that contain the receiver.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchCollections;

/**
 * Fetches all collections that contain the receiver.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchCollectionsForced:(BOOL)forced
                             priority:(AVENetworkPriority*)priority
                         networkToken:(nullable AVENetworkToken*)networkToken;

@end

NS_ASSUME_NONNULL_END
