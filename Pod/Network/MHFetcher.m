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
        NSURL* baseURL = [self generateAPIBaseURLFromURL:[NSURL URLWithString:MHProductionBaseURL]];
        AVEHTTPRequestOperationBuilder* builder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:baseURL];
        
        builder.requestSerializer = [MHJSONRequestSerializer serializer];
        builder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
        
        self.builder = builder;
    }
    return self;
}

- (void)setBaseURL:(NSURL*)baseURL
{
    self.builder.baseURL = [self generateAPIBaseURLFromURL:baseURL];
}

- (NSURL*)generateAPIBaseURLFromURL:(NSURL*)url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", url.absoluteString, [MHSDK sharedSDK].apiVersion]];
}

@end
