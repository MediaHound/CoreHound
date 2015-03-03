//
//  MHFetcher.h
//  mediaHound
//
//  Created by Dustin Bachrach on 2/24/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>
#import <Avenue/Avenue.h>


@interface MHFetcher : NSObject

+ (instancetype)sharedFetcher;

@property (strong, nonatomic, readonly) AVEHTTPRequestOperationBuilder* builder;

- (void)setBaseURL:(NSURL*)baseURL;

- (PMKPromise*)fetchModel:(Class)modelClass
                     path:(NSString*)path
                  keyPath:(NSString*)keyPath
               parameters:(NSDictionary*)parameters
                 priority:(AVENetworkPriority*)priority
             networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)putAndFetchModel:(Class)modelClass
                           path:(NSString*)path
                        keyPath:(NSString*)keyPath
                     parameters:(NSDictionary*)parameters;

- (PMKPromise*)postAndFetchModel:(Class)modelClass
                            path:(NSString*)path
                         keyPath:(NSString*)keyPath
                      parameters:(NSDictionary*)parameters;

- (PMKPromise*)postAndFetchModel:(Class)modelClass
                            path:(NSString*)path
                         keyPath:(NSString*)keyPath
                      parameters:(NSDictionary*)parameters
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))bodyBlock;

@end
