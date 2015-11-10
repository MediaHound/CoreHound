//
//  MHObject+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"

#import <AtSugar/AtSugar.h>

@class MHPagedResponse;

extern const NSInteger MHInternal_DefaultPageSize;

extern NSString* const MHFetchParameterView;
extern NSString* const MHFetchParameterViewFull;

extern NSString* const MHFetchParameterPageSize;
extern NSString* const MHFetchParameterNext;

extern NSString* const kCreateRootSubendpoint;


@interface MHObject (Internal)

- (AnyPromise*)takeAction:(NSString*)action
               parameters:(NSDictionary*)parameters
     predictedSocialBlock:(MHSocial*(^)(MHSocial*, NSDictionary*))predictedSocialBlock;

+ (AnyPromise*)fetchFullViewForMhid:(NSString*)mhid
                           priority:(AVENetworkPriority*)priority
                       networkToken:(AVENetworkToken*)networkToken;

+ (AnyPromise*)fetchRootPagedEndpoint:(NSString*)path
                               forced:(BOOL)forced
                            parameters:(NSDictionary*)parameters
                             priority:(AVENetworkPriority*)priority
                         networkToken:(AVENetworkToken*)networkToken
                                 next:(NSString*)next;

+ (AnyPromise*)fetchRootPagedEndpoint:(NSString*)path
                               forced:(BOOL)forced
                           parameters:(NSDictionary*)parameters
                             priority:(AVENetworkPriority*)priority
                         networkToken:(AVENetworkToken*)networkToken
                                 next:(NSString*)next
                            afterEach:(void(^)(MHPagedResponse*))afterEach;

- (AnyPromise*)fetchPagedEndpoint:(NSString*)path
                           forced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
                             next:(NSString*)next;

- (AnyPromise*)fetchPagedEndpoint:(NSString*)path
                           forced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken
                             next:(NSString*)next
                        afterEach:(void(^)(MHPagedResponse*))afterEach;

- (AnyPromise*)fetchProperty:(NSString*)property
                      forced:(BOOL)forced
                    priority:(AVENetworkPriority*)priority
                networkToken:(AVENetworkToken*)networkToken;

- (void)invalidateCacheForEndpoint:(NSString*)path;

+ (void)invalidateRootCacheForEndpoint:(NSString*)path
                            parameters:(NSDictionary*)parameters;

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

+ (NSString*)rootSubendpointByLookup:(NSString*)lookup;

- (MHPagedResponse*)cachedResponseForPath:(NSString*)path;

- (void)setCachedResponse:(MHPagedResponse*)response forPath:(NSString*)path;

@end
