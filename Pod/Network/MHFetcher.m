//
//  MHFetcher.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHFetcher.h"
#import "MHJSONRequestSerializer.h"
#import "MHJSONResponseSerializerWithData.h"
#import "MHSDK.h"

#import <AtSugar/AtSugar.h>


static NSString* const MHProductionBaseURL = @"https://api.mediahound.com/";


@implementation MHFetcher

@singleton(sharedFetcher)

- (instancetype)init
{
    if (self = [super init]) {
        NSURL* baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", MHProductionBaseURL, [MHSDK sharedSDK].apiVersion]];
        AVEHTTPRequestOperationBuilder* builder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:baseURL];
        
        builder.requestSerializer = [MHJSONRequestSerializer serializer];
        builder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
        
        // Enable SSL Public Key Pinning
        NSBundle* coreHoundBundle = [NSBundle bundleForClass:MHFetcher.class];
        NSString* certificatePath = [coreHoundBundle pathForResource:@"*.mediahound.com" ofType:@"cer"];
        NSData* certificate = [NSData dataWithContentsOfFile:certificatePath];
        
        AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.pinnedCertificates = @[certificate];
        builder.securityPolicy = securityPolicy;
        
        self.builder = builder;
    }
    return self;
}

- (void)setBaseURL:(NSURL*)baseURL
{
    NSURL* finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", baseURL.absoluteString, [MHSDK sharedSDK].apiVersion]];
    self.builder.baseURL = finalURL;
}

@end
