//
//  MHSDK+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHSDK.h"


@interface MHSDK (Internal)

@property (strong, nonatomic) NSString* accessToken;

- (PMKPromise*)refreshOAuthToken;

@end
