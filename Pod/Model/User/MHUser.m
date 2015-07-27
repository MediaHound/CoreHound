//
//  MHUser.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHUser.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"
#import "MHCollection.h"
#import "MHAction.h"
#import "MHLoginSession.h"
#import "MHUser.h"
#import "MHImage.h"
#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"

#import <Avenue/AVENetworkManager.h>

static NSString* const kInterestFeedSubendpoint = @"interestFeed";
static NSString* const kOwnedCollectionsSubendpoint = @"ownedCollections";
static NSString* const kSourceSettingsEndpoint = @"settings/sources";
static NSString* const kFollowingSubendpoint = @"following";
static NSString* const kLikingSubendpoint = @"liking";
static NSString* const kFollowersSubendpoint = @"followers";
static NSString* const kSuggestedSubendpoint = @"suggested";
static NSString* const kSetImageSubendpoint = @"uploadImage";
static NSString* const kSetPasswordSubendpoint = @"updatePassword";
//static NSString* const kFollowedCollectionsSubendpoint = @"followed";

static NSString* const kSuggestedRootSubendpoint = @"suggested";

static NSString* const kForgotUsernameRootSubendpoint = @"forgotusername";
static NSString* const kForgotPasswordRootSubendpoint = @"forgotpassword";


@implementation MHUser

@dynamic metadata;

+ (void)load
{
    [self registerMHObject];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogout:)
                                                 name:MHLoginSessionUserDidLogoutNotification
                                               object:nil];
}

@declare_class_property (mhidPrefix, @"mhusr")
@declare_class_property (rootEndpoint, @"graph/user")

- (BOOL)isCurrentUser
{
    return ([self isEqualToMHObject:[MHLoginSession currentSession].user]);
}

- (AnyPromise*)setProfileImage:(UIImage*)image
{
    if (!image) {
        return [AnyPromise promiseWithValue:nil];
    }
    
    if (!self.isCurrentUser) {
        @throw [NSException exceptionWithName:@"Cannot change the profile image"
                                       reason:@"Only allowed to change the profile image of the currently logged in user."
                                     userInfo:nil];
    }
    
    image = [MHUser imageBySqauareCroppingImage:image];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    return [[MHFetcher sharedFetcher] postAndFetchModel:MHImage.class
                                                   path:[self subendpoint:kSetImageSubendpoint]
                                                keyPath:@"primaryImage"
                                             parameters:nil
                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                  [formData appendPartWithFileData:imageData
                                                              name:@"data"
                                                          fileName:@"data"
                                                          mimeType:@"image/jpeg"];
                              }].thenInBackground(^(MHImage* primaryImage) {
                                  if (![self.primaryImage isEqualToMHObject:primaryImage]) {
                                      self.primaryImage = primaryImage;
                                  }
                                  return self.primaryImage;
                              });
}

- (AnyPromise*)setPassword:(NSString*)newPassword
           currentPassword:(NSString*)currentPassword
{
    if (!self.isCurrentUser) {
        @throw [NSException exceptionWithName:@"Cannot change the password"
                                       reason:@"Only allowed to change the password of the currently logged in user."
                                     userInfo:nil];
    }
    
    return [[AVENetworkManager sharedManager] POST:[self subendpoint:kSetPasswordSubendpoint]
                                        parameters:@{
                                                     @"oldPassword": currentPassword,
                                                     @"newPassword": newPassword
                                                     }
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                      networkToken:nil
                                           builder:[MHFetcher sharedFetcher].builder];
}

#pragma mark - Image Cropping

+ (UIImage*)imageBySqauareCroppingImage:(UIImage*)image
{
    const CGSize size = image.size;
    if (size.width == size.height) {
        // If the image is already square, just return it.
        return image;
    }
    else {
        const CGRect originalRect = CGRectMake(0, 0, size.width, size.height);
        CGRect squareRect;
        
        // Center around the center of the image.
        if (size.width > size.height) {
            squareRect = CGRectInset(originalRect, (size.width - size.height) / 2.0f, 0);
        }
        else {
            squareRect = CGRectInset(originalRect, 0, (size.height - size.width) / 2.0f);
        }
        
        squareRect.origin.x = floor(squareRect.origin.x);
        squareRect.origin.y = floor(squareRect.origin.y);
        
        CGImageRef squareImageRef = CGImageCreateWithImageInRect(image.CGImage, squareRect);
        UIImage* squareImage = [UIImage imageWithCGImage:squareImageRef];
        CGImageRelease(squareImageRef);
        return squareImage;
    }
}

#pragma mark - Notifications

+ (void)userDidLogout:(NSNotification*)notification
{
    [self invalidateRootCacheForEndpoint:[self rootSubendpoint:kSuggestedRootSubendpoint]
                              parameters:nil];
}

@end


@implementation MHUser (Creating)

+ (AnyPromise*)createWithUsername:(NSString*)username
                         password:(NSString*)password
                            email:(NSString*)email
                        firstName:(NSString*)firstName
                         lastName:(NSString*)lastName

{
    NSDictionary* parameters = @{
                                 @"username": username,
                                 @"password": password,
                                 @"email": email,
                                 @"firstName": firstName,
                                 @"lastName": lastName
                                 };
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:kCreateRootSubendpoint]
                                        parameters:parameters
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                      networkToken:nil
                                           builder:[MHFetcher sharedFetcher].builder];
}

@end


@implementation MHUser (Fetching)

+ (AnyPromise*)fetchByUsername:(NSString*)username
{
    return [self fetchByUsername:username
                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                    networkToken:nil];
}

+ (AnyPromise*)fetchByUsername:(NSString*)username
                      priority:(AVENetworkPriority*)priority
                  networkToken:(AVENetworkToken*)networkToken
{
    return [[MHFetcher sharedFetcher] fetchModel:MHUser.class
                                            path:[self rootSubendpointByLookup:username]
                                         keyPath:nil
                                      parameters:@{
                                                   MHFetchParameterView: MHFetchParameterViewFull
                                                   }
                                        priority:priority
                                    networkToken:networkToken];
}

- (AnyPromise*)fetchInterestFeed
{
    return [self fetchInterestFeedForced:NO
                                priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                            networkToken:nil];
}

- (AnyPromise*)fetchInterestFeedForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kInterestFeedSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (AnyPromise*)fetchOwnedCollections
{
    return [self fetchOwnedCollectionsForced:NO
                                    priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                networkToken:nil];
}

- (AnyPromise*)fetchOwnedCollectionsForced:(BOOL)forced
                                  priority:(AVENetworkPriority*)priority
                              networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kOwnedCollectionsSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (AnyPromise*)fetchFollowing
{
    return [self fetchFollowingForced:NO
                             priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                         networkToken:nil];
}

- (AnyPromise*)fetchFollowingForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kFollowingSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (AnyPromise*)fetchLiking
{
    return [self fetchLikingForced:NO
                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                      networkToken:nil];
}

- (AnyPromise*)fetchLikingForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kLikingSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (AnyPromise*)fetchFollowers
{
    return [self fetchFollowersForced:NO
                             priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                         networkToken:nil];
}

- (AnyPromise*)fetchFollowersForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kFollowersSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

+ (AnyPromise*)fetchSuggestedUsers
{
    return [self fetchSuggestedUsersForced:NO
                                  priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                              networkToken:nil];
}

+ (AnyPromise*)fetchSuggestedUsersForced:(BOOL)forced
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchRootPagedEndpoint:[self rootSubendpoint:kSuggestedRootSubendpoint]
                                 forced:forced
                             parameters:nil
                               priority:priority
                           networkToken:networkToken
                                   next:nil];
}

- (AnyPromise*)fetchSuggested
{
    return [self fetchSuggestedForced:NO
                             priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                         networkToken:nil];
}

- (AnyPromise*)fetchSuggestedForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kSuggestedSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

@end


@implementation MHUser (Forgetting)

+ (AnyPromise*)forgotUsernameWithEmail:(NSString*)email
{
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:kForgotUsernameRootSubendpoint]
                                        parameters:@{
                                                     @"email": email
                                                     }
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                      networkToken:nil
                                           builder:[MHFetcher sharedFetcher].builder];
}

+ (AnyPromise*)forgotPasswordWithEmail:(NSString*)email
{
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:kForgotPasswordRootSubendpoint]
                                        parameters:@{
                                                     @"email": email
                                                     }
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                      networkToken:nil
                                           builder:[MHFetcher sharedFetcher].builder];
}

+ (AnyPromise*)forgotPasswordWithUsername:(NSString*)username
{
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:kForgotPasswordRootSubendpoint]
                                        parameters:@{
                                                     @"username": username
                                                     }
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                      networkToken:nil
                                           builder:[MHFetcher sharedFetcher].builder];
}

@end


@implementation MHUser (Internal)

- (void)invalidateOwnedCollections
{
    [self invalidateCacheForEndpoint:[self subendpoint:kOwnedCollectionsSubendpoint]];
    [self fetchOwnedCollectionsForced:YES
                             priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelLow]
                         networkToken:nil];
}

- (void)invalidateFollowing
{
    [self invalidateCacheForEndpoint:[self subendpoint:kFollowingSubendpoint]];
    [self fetchFollowingForced:YES
                      priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelLow]
                  networkToken:nil];
}
//
//- (void)invalidateFollowedCollections
//{
//    [self invalidateCacheForEndpoint:[self subendpoint:kFollowedCollectionsSubendpoint]];
//    [self fetchFollowedCollectionsForced:YES
//                                priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelLow]
//                            networkToken:nil];
//}

@end
