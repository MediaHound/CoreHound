//
//  MHError.h
//  CoreHound
//
//  Created by Dustin Bachrach on 2/9/15.
//
//

#import <Foundation/Foundation.h>

/**
 * The MediaHound error domain.
 * All NSErrors thrown from all MediaHound APIs are in this error domain.
 */
extern NSString* const MHErrorDomain;

#define MHLoginSessionNoSavedCredentialsError 1
#define MHLoginSessionInvalidCredentialsError 2
