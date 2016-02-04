//
//  MHJSONRequestSerializer.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHJSONRequestSerializer.h"
#import "MHSDK+Internal.h"

static NSString* kAccessTokenKey = @"access_token";


@implementation MHJSONRequestSerializer

- (instancetype)init
{
    if (self = [super init]) {
        // Disable HTTP-level caching since it causes probelms with our social metrics
        self.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
    }
    return self;
}

- (NSMutableURLRequest*)requestWithMethod:(NSString*)method
                                URLString:(NSString*)URLString
                               parameters:(id)parameters
                                    error:(NSError* __autoreleasing *)error
{
    NSMutableURLRequest* req =  [super requestWithMethod:method
                                               URLString:URLString
                                              parameters:[self accessTokenifiedParameters:parameters]
                                                   error:error];
    
    [self addAccesTokenHeaderToRequest:req];
    
    return req;
}

- (NSMutableURLRequest*)multipartFormRequestWithMethod:(NSString*)method
                                             URLString:(NSString*)URLString
                                            parameters:(NSDictionary*)parameters
                             constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                                 error:(NSError* __autoreleasing *)error
{
    NSMutableURLRequest* req = [super multipartFormRequestWithMethod:method
                                                           URLString:URLString
                                                          parameters:[self accessTokenifiedParameters:parameters]
                                           constructingBodyWithBlock:block
                                                               error:error];
    
    [self addAccesTokenHeaderToRequest:req];
    
    return req;
}

- (void)addAccesTokenHeaderToRequest:(NSMutableURLRequest*)req
{
    // Set the OAuth access token if the client has configured OAuth.
    NSString* accessToken = [MHSDK sharedSDK].accessToken;
    if (accessToken) {
        [req setValue:[NSString stringWithFormat:@"Bearer %@", accessToken]
   forHTTPHeaderField:@"Authorization"];
    }
}

- (id)accessTokenifiedParameters:(id)parameters
{
    // Set the OAuth access token if the client has configured OAuth.
    NSString* accessToken = [MHSDK sharedSDK].accessToken;
    if (accessToken) {
        if (parameters) {
            NSMutableDictionary* newParameters = [parameters mutableCopy];
            newParameters[kAccessTokenKey] = accessToken;
            return newParameters;
        }
        else {
            return @{ kAccessTokenKey: accessToken };
        }
    }
    else {
        return parameters;
    }
}

@end
