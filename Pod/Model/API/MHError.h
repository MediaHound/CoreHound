//
//  MHError.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

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
