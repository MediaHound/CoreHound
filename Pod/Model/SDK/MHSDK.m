//
//  MHSDK.m
//  CoreHound
//
//  Created by Dustin Bachrach on 4/1/15.
//
//

#import "MHSDK.h"

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
    NSURL* baseURL = [NSURL URLWithString:@"https://cas.mediahound.com/"];
    AVEHTTPRequestOperationBuilder* builder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:baseURL];
    
    return [[AVENetworkManager sharedManager] GET:@"cas/oauth2.0/accessToken"
                                       parameters:@{
                                                    @"client_id": self.clientId,
                                                    @"client_secret": self.clientSecret,
                                                    @"grant_type": @"client_credentials"
                                                    }
                                         priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                     networkToken:nil
                                          builder:builder].then(^(NSDictionary* response) {
        self.accessToken = response[@"accessToken"];
    });
}

@end
