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
@property (strong, nonatomic) NSString* clientId;
@property (strong, nonatomic) NSString* clientSecret;

@property (strong, nonatomic) NSString* userAccessToken;

- (AnyPromise*)refreshOAuthToken;

@end
