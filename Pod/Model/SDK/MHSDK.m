//
//  MHSDK.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHSDK.h"
#import "MHFetcher.h"

#import <AtSugar/AtSugar.h>
#import <Avenue/Avenue.h>


@interface MHSDK ()

@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* clientId;
@property (strong, nonatomic) NSString* clientSecret;

@end


@implementation MHSDK

@singleton (sharedSDK)

- (PMKPromise*)configureWithClientId:(NSString*)clientId
                        clientSecret:(NSString*)clientSecret
{
    self.clientId = clientId;
    self.clientSecret = clientSecret;
    
    return [self refreshOAuthToken];
}

- (PMKPromise*)refreshOAuthToken
{
    return [[AVENetworkManager sharedManager] GET:@"cas/oauth2.0/accessToken"
                                       parameters:@{
                                                    @"client_id": self.clientId,
                                                    @"client_secret": self.clientSecret,
                                                    @"grant_type": @"client_credentials"
                                                    }
                                         priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                     networkToken:nil
                                          builder:[MHFetcher sharedFetcher].builder].then(^(NSDictionary* response) {
        self.accessToken = response[@"accessToken"];
    });
}

@end
