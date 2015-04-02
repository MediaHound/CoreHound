//
//  MHFetcher.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHFetcher.h"
#import "MHJSONRequestSerializer.h"
#import "MHJSONResponseSerializerWithData.h"

#import <AtSugar/AtSugar.h>


static NSString* const MHProductionBaseURL = @"https://api-v10.mediahound.com/";


@implementation MHFetcher

@singleton(sharedFetcher)

- (instancetype)init
{
    if (self = [super init]) {
        AVEHTTPRequestOperationBuilder* builder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:[NSURL URLWithString:MHProductionBaseURL]];
        
        builder.requestSerializer = [MHJSONRequestSerializer serializer];
        builder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
        
        // Enable SSL Public Key Pinning
        AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.validatesCertificateChain = NO;
        builder.securityPolicy = securityPolicy;
        
        self.builder = builder;
    }
    return self;
}

- (void)setBaseURL:(NSURL*)baseURL
{
    self.builder.baseURL = baseURL;
}

@end
