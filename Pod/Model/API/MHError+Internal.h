//
//  MHError+Internal.h
//  CoreHound
//
//  Created by Dustin Bachrach on 2/10/15.
//
//

#import "MHError.h"

static inline NSError* MHErrorMake(NSInteger code, NSDictionary* userInfo)
{
    return [[NSError alloc] initWithDomain:MHErrorDomain
                                      code:code
                                  userInfo:userInfo];
}
