//
//  MHSDK.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHSDK.h"
#import "MHFetcher.h"
#import "MHJSONResponseSerializerWithData.h"

#import <AtSugar/AtSugar.h>
#import <Avenue/Avenue.h>


@interface MHSDK ()

@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* clientId;
@property (strong, nonatomic) NSString* clientSecret;

@end


@implementation MHSDK

@singleton (sharedSDK)

- (AnyPromise*)configureWithClientId:(NSString*)clientId
                        clientSecret:(NSString*)clientSecret
{
    self.clientId = clientId;
    self.clientSecret = clientSecret;
    
    return [self refreshOAuthToken];
}

- (AnyPromise*)refreshOAuthToken
{
    AVEHTTPRequestOperationBuilder* mainBuilder = [MHFetcher sharedFetcher].builder;
    
    AVEHTTPRequestOperationBuilder* oauthBuilder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:mainBuilder.baseURL];
    
    oauthBuilder.requestSerializer = [AFHTTPRequestSerializer serializer];
    [oauthBuilder.requestSerializer setAuthorizationHeaderFieldWithUsername:self.clientId
                                                                   password:self.clientSecret];
    oauthBuilder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
    
    oauthBuilder.securityPolicy = mainBuilder.securityPolicy;
    
    
    return [[AVENetworkManager sharedManager] POST:@"security/oauth/token"
                                       parameters:@{
                                                    @"client_id": self.clientId,
                                                    @"client_secret": self.clientSecret,
                                                    @"grant_type": @"client_credentials",
                                                    @"scope": @"public_profile"
                                                    }
                                         priority:nil
                                     networkToken:nil
                                          builder:oauthBuilder].then(^(NSDictionary* response) {
        self.accessToken = response[@"access_token"];
    });
}

- (NSString*)apiVersion
{
    return @"1.2";
}

@end
