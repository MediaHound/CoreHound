//
//  MHError.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The MediaHound error domain.
 * All NSErrors thrown from all MediaHound APIs are in this error domain.
 */
extern NSString* const MHErrorDomain;

#define MHLoginSessionNoSavedCredentialsError 1
#define MHLoginSessionInvalidCredentialsError 2
