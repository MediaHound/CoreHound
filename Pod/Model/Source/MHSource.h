//
//  Source.h
//  MediaHound
//
//  Created by Tai Bo on 10/2/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHObject.h"
#import "MHSubscription.h"
#import "MHSourcePreference.h"

// TODO: Should have MH Prefix
extern NSString* const iTunesSourceName;


@interface MHSource : MHObject

@property (strong, nonatomic) NSArray<MHSubscription, Optional>* subscriptions;
@property (strong, nonatomic) NSArray<Optional>* allMediums;

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

@end


@interface MHSource (Fetching)

+ (PMKPromise*)fetchAll;
+ (PMKPromise*)fetchAllForced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken;

@end


