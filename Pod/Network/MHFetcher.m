//
//  MHFetcher.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHFetcher.h"
#import "MHJSONRequestSerializer.h"
#import "MHJSONResponseSerializerWithData.h"

#import <AtSugar/AtSugar.h>


static NSString* const MHProductionBaseURL = @"https://api-v11.mediahound.com/";


@implementation MHFetcher

@singleton(sharedFetcher)

- (instancetype)init
{
    if (self = [super init]) {
        AVEHTTPRequestOperationBuilder* builder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:[NSURL URLWithString:MHProductionBaseURL]];
        
        builder.requestSerializer = [MHJSONRequestSerializer serializer];
        builder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
        
        // Enable SSL Public Key Pinning
        NSBundle* coreHoundBundle = [NSBundle bundleForClass:MHFetcher.class];
        NSString* certificatePath = [coreHoundBundle pathForResource:@"*.mediahound.com" ofType:@"cer"];
        NSData* certificate = [NSData dataWithContentsOfFile:certificatePath];
        
        AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.validatesCertificateChain = NO;
        securityPolicy.pinnedCertificates = @[certificate];
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
