//
//  MHLoginSession.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import <JSONModel/JSONModel.h>

@class MHUser;

NS_ASSUME_NONNULL_BEGIN

/**
 * Notification raised when a login is succesful.
 */
extern NSString* const MHLoginSessionUserDidLoginNotification;

/**
 * Notification raised when a logout is succesful.
 */
extern NSString* const MHLoginSessionUserDidLogoutNotification;


/**
 * MHLoginSession allows a user to be logged in or logged out.
 */
@interface MHLoginSession : NSObject

/**
 * The user that is logged in for the session.
 */
+ (nullable MHUser*)currentUser;

/**
 * Logs a user in with credentials stored in the Keychain.
 * Credentials are only saved after a succesful call to `loginWithUsername:password:` or `loginWithAccessToken:`.
 * @return A promise which resolves with an MHUser.
 * If there are no saved credentials, the promise fails with an `MHLoginSessionNoSavedCredentialsError`.
 * If there are saved credentials, but the credentials are no longer valid, the promise fails
 *   with an `MHLoginSessionInvalidCredentialsError`.
 */
+ (AnyPromise*)loginUsingSavedCredentials;

/**
 * Logs in a user with a given username and password.
 * @param username The username of the user to login
 * @param password The password of the user to login
 * @return A promise which resolves with an MHUser.
 * If the credentials are invalid, the promise fails with an `MHLoginSessionInvalidCredentialsError`.
 * If login is succesful, the user's credentials will be persisted to the Keychain securely.
 * You should NOT store the username and password your self.
 * To use this, your application must have permission to use the *password grant* flow.
 */
+ (AnyPromise*)loginWithUsername:(NSString*)username
                        password:(NSString*)password;

+ (NSURL*)loginDialogURLWithRedirectURL:(NSURL*)redirect;

/**
 * Logs in a user with an access token received from `loginDialogURLWithRedirectURL:`.
 * @param accessToken The access token received through the OAuth login flows.
 * @return A promise which resolves with an MHUser.
 * If login is succesful, the access token will be persisted to the Keychain securely.
 */
+ (AnyPromise*)loginWithAccessToken:(NSString*)accessToken;

/**
 * Logs out the user from the session.
 */
+ (void)logout;

@end

NS_ASSUME_NONNULL_END
