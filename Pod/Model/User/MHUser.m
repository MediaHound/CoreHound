//
//  MHUser.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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
//static NSString* const kFollowedCollectionsSubendpoint = @"followed";

static MHPagedResponse* s_suggestedUsers = nil;


@implementation MHUser

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

- (PMKPromise*)setProfileImage:(UIImage*)image
{
    if (!image) {
        return [PMKPromise promiseWithValue:nil];
    }
    
    if (!self.isCurrentUser) {
        @throw [NSException exceptionWithName:@"Cannot change the profile image"
                                       reason:@"Only allowed to change the profile image of the currently logged in user."
                                     userInfo:nil];
    }
    
    image = [MHUser imageBySqauareCroppingImage:image];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    return [[MHFetcher sharedFetcher] postAndFetchModel:MHImage.class
                                                  path:[self subendpoint:@"uploadImage"]
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

- (PMKPromise*)setPassword:(NSString*)newPassword
           currentPassword:(NSString*)currentPassword
{
    if (!self.isCurrentUser) {
        @throw [NSException exceptionWithName:@"Cannot change the password"
                                       reason:@"Only allowed to change the password of the currently logged in user."
                                     userInfo:nil];
    }
    
    return [[AVENetworkManager sharedManager] POST:[self subendpoint:@"updatePassword"]
                                        parameters:@{
                                                     @"oldPassword": currentPassword,
                                                     @"newPassword": newPassword
                                                     }
                                      networkToken:nil
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
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
    s_suggestedUsers = nil;
}

@end


@implementation MHUser (Creating)

+ (PMKPromise*)createWithUsername:(NSString*)username
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
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:@"new"]
                                        parameters:parameters
                                      networkToken:nil
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                           builder:[MHFetcher sharedFetcher].builder];
}

@end


@implementation MHUser (Fetching)

+ (PMKPromise*)fetchByUsername:(NSString*)username
{
    return [self fetchByUsername:username
                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                    networkToken:nil];
}

+ (PMKPromise*)fetchByUsername:(NSString*)username
                      priority:(AVENetworkPriority*)priority
                  networkToken:(AVENetworkToken*)networkToken
{
    NSString* path = [NSString stringWithFormat:@"%@/lookup/%@", [self.class rootEndpoint], username];
    return [[MHFetcher sharedFetcher] fetchModel:MHUser.class
                                            path:path
                                         keyPath:nil
                                      parameters:@{
                                                   MHFetchParameterView: MHFetchParameterViewFull
                                                   }
                                        priority:priority
                                    networkToken:networkToken];
}

- (PMKPromise*)fetchInterestFeed
{
    return [self fetchInterestFeedForced:NO
                                priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                            networkToken:nil];
}

- (PMKPromise*)fetchInterestFeedForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kInterestFeedSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (PMKPromise*)fetchOwnedCollections
{
    return [self fetchOwnedCollectionsForced:NO
                                    priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                networkToken:nil];
}

- (PMKPromise*)fetchOwnedCollectionsForced:(BOOL)forced
                                  priority:(AVENetworkPriority*)priority
                              networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kOwnedCollectionsSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

- (PMKPromise*)fetchFollowing
{
    return [self fetchFollowingForced:NO
                             priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                         networkToken:nil];
}

- (PMKPromise*)fetchFollowingForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:kFollowingSubendpoint]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

+ (PMKPromise*)fetchSuggestedUsers
{
    
    @synchronized (self) {
        if (s_suggestedUsers) {
            return [PMKPromise promiseWithValue:s_suggestedUsers];
        }
    }
    
    return [[MHFetcher sharedFetcher] fetchModel:MHPagedResponse.class
                                            path:[self rootSubendpoint:@"suggested"]
                                         keyPath:nil
                                      parameters:@{
                                                   MHFetchParameterView: MHFetchParameterViewFull
                                                   }
                                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                    networkToken:nil].thenInBackground(^(MHPagedResponse* response) {
        @synchronized (self) {
            s_suggestedUsers = response;
        }
        
        return response;
    });
}

- (PMKPromise*)fetchSuggested
{
    return [self fetchSuggestedForced:NO
                             priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                         networkToken:nil];
}

- (PMKPromise*)fetchSuggestedForced:(BOOL)forced
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:@"suggested"]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

@end


@implementation MHUser (Forgetting)

+ (PMKPromise*)forgotUsernameWithEmail:(NSString*)email
{
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:@"forgotusername"]
                                        parameters:@{
                                                     @"email": email
                                                     }
                                      networkToken:nil
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                           builder:[MHFetcher sharedFetcher].builder];
}

+ (PMKPromise*)forgotPasswordWithEmail:(NSString*)email
{
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:@"forgotpassword"]
                                        parameters:@{
                                                     @"email": email
                                                     }
                                      networkToken:nil
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
                                           builder:[MHFetcher sharedFetcher].builder];
}

+ (PMKPromise*)forgotPasswordWithUsername:(NSString*)username
{
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:@"forgotpassword"]
                                        parameters:@{
                                                     @"username": username
                                                     }
                                      networkToken:nil
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
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
