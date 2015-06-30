//
//  MHSource.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"
#import "MHSubscription.h"
#import "MHSourcePreference.h"


@interface MHSource : MHObject

@property (strong, atomic) MHSourceMetadata* metadata;
@property (strong, nonatomic) NSArray<MHSubscription>* subscriptions;
@property (strong, nonatomic) NSArray* allMediums;

- (PMKPromise*)connect;
- (PMKPromise*)connectWithPreference:(MHSourcePreference)preference;
- (PMKPromise*)connectWithPreference:(MHSourcePreference)preference description:(NSString*)description;
- (PMKPromise*)disconnect;
- (PMKPromise*)updatePreference:(MHSourcePreference)preference;
- (PMKPromise*)updateDescription:(NSString*)description;

@property (nonatomic, readonly) BOOL isITunes;
@property (nonatomic, readonly) BOOL isSpotify;
@property (nonatomic, readonly) BOOL isRdio;
@property (nonatomic, readonly) BOOL isNetflix;
@property (nonatomic, readonly) BOOL isHulu;

@end


@interface MHSource (Fetching)

+ (PMKPromise*)fetchAll;
+ (PMKPromise*)fetchAllForced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken;

@end


