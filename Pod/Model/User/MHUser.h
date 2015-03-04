//
//  User.h
//  MediaHound
//
//  Created by Tai Bo on 7/18/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHObject.h"


@protocol MHUser <NSObject>

@end


@interface MHUser : MHObject

@property (strong, atomic) MHUserMetadata* metadata;

- (PMKPromise*)setProfileImage:(UIImage*)image;

- (PMKPromise*)setPassword:(NSString*)newPassword
           currentPassword:(NSString*)currentPassword;

@property (nonatomic, readonly) BOOL isCurrentUser;

@end


@interface MHUser (Creating)

+ (PMKPromise*)createWithUsername:(NSString*)username
                         password:(NSString*)password
                            email:(NSString*)email
                        firstName:(NSString*)firstName
                         lastName:(NSString*)lastName;

@end


@interface MHUser (Fetching)

+ (PMKPromise*)fetchByUsername:(NSString*)username;
+ (PMKPromise*)fetchByUsername:(NSString*)username
                      priority:(AVENetworkPriority*)priority
                  networkToken:(AVENetworkToken*)networkToken;

+ (PMKPromise*)fetchSuggestedUsers;

- (PMKPromise*)fetchInterestFeed;
- (PMKPromise*)fetchInterestFeedForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchOwnedCollections;
- (PMKPromise*)fetchOwnedCollectionsForced:(BOOL)forced
                                  priority:(AVENetworkPriority*)priority
                              networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchFollowing;
- (PMKPromise*)fetchFollowingForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchSuggested;
- (PMKPromise*)fetchSuggestedForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken;

@end


@interface MHUser (Forgetting)

+ (PMKPromise*)forgotUsernameWithEmail:(NSString*)email;

+ (PMKPromise*)forgotPasswordWithEmail:(NSString*)email;
+ (PMKPromise*)forgotPasswordWithUsername:(NSString*)username;

@end
