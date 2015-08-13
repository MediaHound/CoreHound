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
 * Notificaiton raised when a login is succesful.
 */
extern NSString* const MHLoginSessionUserDidLoginNotification;

/**
 * Notificaiton raised when a logout is succesful.
 */
extern NSString* const MHLoginSessionUserDidLogoutNotification;


/**
 * An MHLoginSession represents a logged in session on behalf of a user.
 */
@interface MHLoginSession : JSONModel

/**
 * The user that is logged in for this session.
 */
@property (strong, nullable, nonatomic, readonly) MHUser* user;

/**
 * Creates a login session by logging a user in with credentials store in the Keychain.
 * Credentials are only saved after a succesful call to `loginWithUsername:password:`.
 * @return A promise which resolves with a valid MHLoginSession.
 * If there are no saved credentials, the promise propogates with an MHLoginSessionNoSavedCredentialsError.
 * If there are saved credentials, but the credentials are no longer valid, the promise propogates
 *   with an MHLoginSessionInvalidCredentialsError.
 */
+ (AnyPromise*)loginUsingSavedCredentials;

/**
 * Create a login session by logging in a user with a given username and password.
 * @param username The username of the user to login
 * @param password The password of the user to login
 * @return A promise which resolves with a valid MHLoginSession.
 * If the credentials are invalid, the promise propogates a `MHLoginSessionInvalidCredentialsError`.
 * If login is succesful, the user's credentials will be persisted to the Keychain securely.
 * You should NOT store the username and password your self.
 */
+ (AnyPromise*)loginWithUsername:(NSString*)username
                        password:(NSString*)password;

/**
 * Logs out the user from this session.
 * If the receiver is the current session, it will no longer 
 * be the current session after this method is called.
 */
- (void)logout;

/**
 * Returns the current login session.
 */
+ (instancetype)currentSession;

@end

NS_ASSUME_NONNULL_END
