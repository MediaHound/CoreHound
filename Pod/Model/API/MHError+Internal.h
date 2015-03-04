//
//  MHError+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHError.h"

/**
 * Creates an MHError object with an error code and userInfo.
 * @param code Error code, which should be defined in MHError.h.
 * @param userInfo a dictionary of arbitrary error info.
 */
static inline NSError* MHErrorMake(NSInteger code, NSDictionary* userInfo)
{
    return [[NSError alloc] initWithDomain:MHErrorDomain
                                      code:code
                                  userInfo:userInfo];
}
