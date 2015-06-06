//
//  MHObject+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHObject.h"

#import <AtSugar/AtSugar.h>

@class MHPagedResponse;

extern const NSInteger MHInternal_DefaultPageSize;

extern NSString* const MHFetchParameterView;
extern NSString* const MHFetchParameterViewFull;


@interface MHObject (Internal)

- (PMKPromise*)takeAction:(NSString*)action parameters:(NSDictionary*)parameters predictedSocialBlock:(MHSocial*(^)(MHSocial*, NSDictionary*))predictedSocialBlock;

+ (PMKPromise*)fetchFullViewForMhid:(NSString*)mhid
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken;

+ (PMKPromise*)fetchRootPagedEndpoint:(NSString*)path
                               forced:(BOOL)forced
                            parameters:(NSDictionary*)parameters
                             priority:(AVENetworkPriority*)priority
                         networkToken:(AVENetworkToken*)networkToken
                                 next:(NSString*)next;

+ (PMKPromise*)fetchRootPagedEndpoint:(NSString*)path
                               forced:(BOOL)forced
                           parameters:(NSDictionary*)parameters
                             priority:(AVENetworkPriority*)priority
                         networkToken:(AVENetworkToken*)networkToken
                                 next:(NSString*)next
                            afterEach:(void(^)(MHPagedResponse*))afterEach;

- (PMKPromise*)fetchPagedEndpoint:(NSString*)path
                           forced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
                             next:(NSString*)next;

- (PMKPromise*)fetchPagedEndpoint:(NSString*)path
                           forced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
                             next:(NSString*)next
                        afterEach:(void(^)(MHPagedResponse*))afterEach;

- (PMKPromise*)fetchProperty:(NSString*)property
                      forced:(BOOL)forced
                    priority:(AVENetworkPriority*)priority
                networkToken:(AVENetworkToken*)networkToken;

- (void)invalidateCacheForEndpoint:(NSString*)path;

- (void)invalidateCollections;

+ (void)registerMHObject;

+ (NSArray*)registeredMHObjects;

+ (NSDictionary*)prefixModelMapping;

+ (NSString*)mhidPrefix;

+ (NSString*)rootEndpoint;

+ (NSString*)endpointForMhid:(NSString*)mhid;

- (NSString*)endpoint;

- (NSString*)subendpoint:(NSString*)sub;

+ (NSString*)rootSubendpoint:(NSString*)sub;

@end
