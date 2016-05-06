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
    NSMutableURLRequest* req =  [super requestWithMethod:method
                                               URLString:URLString
                                              parameters:parameters
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
                                                          parameters:parameters
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
        NSString* auth = [NSString stringWithFormat:@"Bearer %@", accessToken];
        [req setValue:auth forHTTPHeaderField:@"Authorization"];
    }
}

@end
