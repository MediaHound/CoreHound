//
//  MHFetcher.m
//  mediaHound
//
//  Created by Dustin Bachrach on 3/13/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHFetcher.h"
#import "MHJSONResponseSerializerWithData.h"

#import <AtSugar/AtSugar.h>
#import <JSONModel/JSONModel.h>


typedef id(^TransformBlock)(id);

static NSString* const MHProductionBaseURL = @"https://api-v10.mediahound.com/";


@interface MHFetcher ()

@property (strong, nonatomic, readwrite) AVEHTTPRequestOperationBuilder* builder;

@end


@implementation MHFetcher

@singleton(sharedFetcher)

- (instancetype)init
{
    if (self = [super init]) {
        AVEHTTPRequestOperationBuilder* builder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:[NSURL URLWithString:MHProductionBaseURL]];
        
        AFJSONRequestSerializer* serializer = [AFJSONRequestSerializer serializer];
        // Disable HTTP-level caching since it causes probelms with our social metrics
        serializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
        builder.requestSerializer = serializer;
        builder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
        
        // Enable SSL Public Key Pinning
        AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.validatesCertificateChain = NO;
        builder.securityPolicy = securityPolicy;
        
        _builder = builder;
    }
    return self;
}

- (void)setBaseURL:(NSURL*)baseURL
{
    self.builder.baseURL = baseURL;
}

- (PMKPromise*)fetchWithAction:(NSString*)action
                          path:(NSString*)path
                    parameters:(NSDictionary*)parameters
     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))bodyBlock
                      priority:(AVENetworkPriority*)priority
                  networkToken:(AVENetworkToken*)networkToken
                transformBlock:(TransformBlock)transformBlock
{
    if ([action isEqualToString:@"GET"]) {
        return [[AVENetworkManager sharedManager] GET:path
                                          parameters:parameters
                                        networkToken:networkToken
                                            priority:priority
                                              builder:self.builder].thenInBackground(transformBlock);
    }
    else if ([action isEqualToString:@"PUT"]) {
        return [[AVENetworkManager sharedManager] PUT:path
                                           parameters:parameters
                                         networkToken:networkToken
                                             priority:priority
                                              builder:self.builder].thenInBackground(transformBlock);
    }
    else if ([action isEqualToString:@"POST"]) {
        if (bodyBlock) {
            return [[AVENetworkManager sharedManager] POST:path
                                                parameters:parameters
                                 constructingBodyWithBlock:bodyBlock
                                              networkToken:networkToken
                                                  priority:priority
                                                   builder:self.builder].thenInBackground(transformBlock);
        }
        else {
            return [[AVENetworkManager sharedManager] POST:path
                                                parameters:parameters
                                              networkToken:networkToken
                                                  priority:priority
                                                   builder:self.builder].thenInBackground(transformBlock);
        }
    }
    else {
        @throw [NSException exceptionWithName:@"Invalid fetch action"
                                       reason:@"The fetch action must be `GET`, `POST`, or `PUT`."
                                     userInfo:nil];
    }
}

- (TransformBlock)transformBlockForModel:(Class)modelClass keyPath:(NSString*)keyPath
{
    return ^id(id responseObject) {
        NSDictionary* dict = (keyPath) ? [responseObject valueForKeyPath:keyPath] : responseObject;
        NSError* error = nil;
        id model = [[modelClass alloc] initWithDictionary:dict error:&error];
        
        if (model) {
            return model;
        }
        else {
            return error;
        }
    };
}

- (PMKPromise*)fetchModel:(Class)modelClass
                     path:(NSString*)path
                  keyPath:(NSString*)keyPath
               parameters:(NSDictionary*)parameters
                 priority:(AVENetworkPriority*)priority
             networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchWithAction:@"GET"
                            path:path
                      parameters:parameters
       constructingBodyWithBlock:nil
                            priority:priority
                    networkToken:networkToken
                  transformBlock:[self transformBlockForModel:modelClass keyPath:keyPath]];
}

- (PMKPromise*)putAndFetchModel:(Class)modelClass
                           path:(NSString*)path
                        keyPath:(NSString*)keyPath
                     parameters:(NSDictionary*)parameters
{
    return [self fetchWithAction:@"PUT"
                            path:path
                      parameters:parameters
       constructingBodyWithBlock:nil
                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                          postponeable:NO]
                    networkToken:nil
            transformBlock:[self transformBlockForModel:modelClass keyPath:keyPath]];
}

- (PMKPromise*)postAndFetchModel:(Class)modelClass
                            path:(NSString*)path
                         keyPath:(NSString*)keyPath
                      parameters:(NSDictionary*)parameters
{
    return [self fetchWithAction:@"POST"
                            path:path
                      parameters:parameters
       constructingBodyWithBlock:nil
                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                          postponeable:NO]
                    networkToken:nil
                  transformBlock:[self transformBlockForModel:modelClass keyPath:keyPath]];
}

- (PMKPromise*)postAndFetchModel:(Class)modelClass
                            path:(NSString*)path
                         keyPath:(NSString*)keyPath
                      parameters:(NSDictionary*)parameters
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))bodyBlock
{
    return [self fetchWithAction:@"POST"
                            path:path
                      parameters:parameters
       constructingBodyWithBlock:bodyBlock
                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                          postponeable:NO]
                    networkToken:nil
                  transformBlock:[self transformBlockForModel:modelClass keyPath:keyPath]];
}

@end
