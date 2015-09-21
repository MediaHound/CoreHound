//
//  MHSource.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"
#import "MHSubscription.h"
#import "MHSourcePreference.h"

NS_ASSUME_NONNULL_BEGIN


@interface MHSource : MHObject

@property (strong, atomic) MHSourceMetadata* metadata;
@property (strong, nullable, nonatomic) NSArray* subscriptions;
@property (strong, nullable, nonatomic) NSArray* allMediums;

- (AnyPromise*)connect;
- (AnyPromise*)connectWithPreference:(MHSourcePreference)preference;
- (AnyPromise*)disconnect;
- (AnyPromise*)updatePreference:(MHSourcePreference)preference;

@property (nonatomic, readonly) BOOL isITunes;
@property (nonatomic, readonly) BOOL isSpotify;
@property (nonatomic, readonly) BOOL isRdio;
@property (nonatomic, readonly) BOOL isNetflix;
@property (nonatomic, readonly) BOOL isHulu;

@end


@interface MHSource (Fetching)

+ (AnyPromise*)fetchAll;
+ (AnyPromise*)fetchAllForced:(BOOL)forced
                     priority:(nullable AVENetworkPriority*)priority
                 networkToken:(nullable AVENetworkToken*)networkToken;

@end

NS_ASSUME_NONNULL_END
