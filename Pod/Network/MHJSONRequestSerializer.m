//
//  MHJSONRequestSerializer.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHJSONRequestSerializer.h"
#import "MHSDK+Internal.h"


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
    return [super requestWithMethod:method
                          URLString:URLString
                         parameters:[self accessTokenifiedParameters:parameters]
                              error:error];
}

- (NSMutableURLRequest*)multipartFormRequestWithMethod:(NSString*)method
                                             URLString:(NSString*)URLString
                                            parameters:(NSDictionary*)parameters
                             constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                                 error:(NSError* __autoreleasing *)error
{
    return [super multipartFormRequestWithMethod:method
                                       URLString:URLString
                                      parameters:[self accessTokenifiedParameters:parameters]
                       constructingBodyWithBlock:block
                                           error:error];
}

- (id)accessTokenifiedParameters:(id)parameters
{
    // Set the OAuth access token if the client has configured OAuth.
    NSString* accessToken = [MHSDK sharedSDK].accessToken;
    if (accessToken) {
        if (parameters) {
            NSMutableDictionary* newParameters = [parameters mutableCopy];
            newParameters[@"access_token"] = accessToken;
            return newParameters;
        }
        else {
            return @{ @"access_token": accessToken };
        }
    }
    else {
        return parameters;
    }
}

@end
