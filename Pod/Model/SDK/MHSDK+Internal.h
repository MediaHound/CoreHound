//
//  MHSDK+Internal.h
//  Pods
//
//  Created by Dustin Bachrach on 4/1/15.
//
//

#import "MHSDK.h"


@interface MHSDK (Internal)

@property (strong, nonatomic) NSString* accessToken;

- (PMKPromise*)refreshOAuthToken;

@end
