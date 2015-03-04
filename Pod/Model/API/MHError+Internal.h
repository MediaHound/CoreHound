//
//  MHError+Internal.h
//  CoreHound
//
//  Created by Dustin Bachrach on 2/10/15.
//
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
