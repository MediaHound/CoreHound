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

#define MHLoginSessionNoSavedCredentialsError 1
#define MHLoginSessionInvalidCredentialsError 2
