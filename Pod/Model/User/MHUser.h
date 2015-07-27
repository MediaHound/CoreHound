//
//  MHUser.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"


/**
 * An MHUser is a user that interacts with The Entertainment Graph.
 * A user can be the logged in user or someone else.
 */
@interface MHUser : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHUserMetadata* metadata;

/**
 * Sets the user's profile image to the provided image.
 * Can only be called on the currently logged in user.
 * @param image The user's new profile image
 * @return A promise which resolves when the profile image is updated
 */
- (AnyPromise*)setProfileImage:(UIImage*)image;

/**
 * Change the user's password.
 * Can only be called on the currently logged in user.
 * @param newPassword The user's new password
 * @param currentPassword The user's current password, which will be changed
 * @return A promise which resolves when the user's password has been changed
 */
- (AnyPromise*)setPassword:(NSString*)newPassword
           currentPassword:(NSString*)currentPassword;

/**
 * Whether the user is the currently logged in user
 */
@property (nonatomic, readonly) BOOL isCurrentUser;

@end


@interface MHUser (Creating)

/**
 * Creates a user in The Entertainment Graph.
 * @param username The username that identifies the user publicly
 * @param password The password that the authenticates the user
 * @param email The email address for contacting the user
 * @param firstName First name for the user
 * @param lastName Last name for the user
 * @return a promise which resolves when the user has been created.
 * After the promise resolves, you can login as the user using `MHLoginSession`.
 */
+ (AnyPromise*)createWithUsername:(NSString*)username
                         password:(NSString*)password
                            email:(NSString*)email
                        firstName:(NSString*)firstName
                         lastName:(NSString*)lastName;

@end


@interface MHUser (Fetching)

/**
 * Fetches an MHUser by a username.
 * @param username The username to look for.
 * @return A promise which resolves with an MHUser
 * If no user with this username exists, the promise propogates an error.
 */
+ (AnyPromise*)fetchByUsername:(NSString*)username;

/**
 * Fetches an MHUser by a username.
 * @param username The username to look for.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHUser
 * If no user with this username exists, the promise propogates an error.
 */
+ (AnyPromise*)fetchByUsername:(NSString*)username
                      priority:(AVENetworkPriority*)priority
                  networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches a set of suggested users that may be of interest to follow.
 * @return A promise which resolves with an MHPagedResponse.
 */
+ (AnyPromise*)fetchSuggestedUsers;

/**
 * Fetches a set of suggested users that may be of interest to follow.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
+ (AnyPromise*)fetchSuggestedUsersForced:(BOOL)forced
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches the interest feed for this user.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchInterestFeed;

/**
 * Fetches the interest feed for this user.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchInterestFeedForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all of the collections created by this user.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchOwnedCollections;

/**
 * Fetches all of the collections created by this user.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchOwnedCollectionsForced:(BOOL)forced
                                  priority:(AVENetworkPriority*)priority
                              networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all the things that this user is following.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchFollowing;

/**
 * Fetches all the things that this user is following.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchFollowingForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all the things that have been liked by this user.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchLiking;

/**
 * Fetches all the things that have been liked by this user.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchLikingForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches the followers (MHUsers) who follow this user.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchFollowers;

/**
 * Fetches the followers (MHUsers) for this user.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchFollowersForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches suggested content for this user.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchSuggested;

/**
 * Fetches suggested content for this user.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchSuggestedForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken;

@end


@interface MHUser (Forgetting)

/**
 * Perform the forgot username flow for a user, given the user's email.
 * @param email The email of the user.
 * @return A promise which resolves when the action is finished.
 */
+ (AnyPromise*)forgotUsernameWithEmail:(NSString*)email;

/**
 * Perform the forgot password flow for a user, given the user's email.
 * @param email The email of the user.
 * @return A promise which resolves when the action is finished.
 */
+ (AnyPromise*)forgotPasswordWithEmail:(NSString*)email;

/**
 * Perform the forgot password flow for a user, given the user's username.
 * @param username The username of the user.
 * @return A promise which resolves when the action is finished.
 */
+ (AnyPromise*)forgotPasswordWithUsername:(NSString*)username;

@end
