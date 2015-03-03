//
//  LoginSession.h
//  mediaHound
//
//  Created by Dustin Bachrach on 4/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import <JSONModel/JSONModel.h>

@class MHUser;

extern NSString* const MHLoginSessionUserDidLoginNotification;
extern NSString* const MHLoginSessionUserDidLogoutNotification;


@interface MHLoginSession : JSONModel

@property (strong, nonatomic, readonly) MHUser* user;

+ (PMKPromise*)loginUsingSavedCredentials;

+ (PMKPromise*)loginWithUsername:(NSString*)username
                     password:(NSString*)password;

- (void)logout;

+ (instancetype)currentSession;

@end
