//
//  MHError.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The MediaHound error domain.
 * All NSErrors returned directly from MediaHound APIs are in this error domain.
 */
extern NSString* const MHErrorDomain;

/**
 * A call to [MHLoginSession loginUsingSavedCredentials] failed because there
 * were no login credentials found.
 */
#define MHLoginSessionNoSavedCredentialsError 1

/**
 * A call to [MHLoginSession loginWithUsername:password:] failed because the
 * credentials were invalid.
 */
#define MHLoginSessionInvalidCredentialsError 2

/**
 * NSError userInfo key that will contain response string
 * Returned on failing network calls
 */
extern NSString* const MHJSONResponseSerializerWithStringKey;

NS_ASSUME_NONNULL_END
