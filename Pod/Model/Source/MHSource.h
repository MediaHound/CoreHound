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
@property (strong, nonatomic) NSArray* subscriptions;
@property (strong, nonatomic) NSArray* allMediums;

- (AnyPromise*)connect;
- (AnyPromise*)connectWithPreference:(MHSourcePreference)preference;
- (AnyPromise*)connectWithPreference:(MHSourcePreference)preference description:(NSString*)description;
- (AnyPromise*)disconnect;
- (AnyPromise*)updatePreference:(MHSourcePreference)preference;
- (AnyPromise*)updateDescription:(NSString*)description;

@property (nonatomic, readonly) BOOL isITunes;
@property (nonatomic, readonly) BOOL isSpotify;
@property (nonatomic, readonly) BOOL isRdio;
@property (nonatomic, readonly) BOOL isNetflix;
@property (nonatomic, readonly) BOOL isHulu;

@end


@interface MHSource (Fetching)

+ (AnyPromise*)fetchAll;
+ (AnyPromise*)fetchAllForced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken;

@end


