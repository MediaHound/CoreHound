//
//  Contributor.h
//  mediaHound
//
//  Created by Dustin Bachrach on 3/16/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHObject.h"


@interface MHContributor : MHObject

@property (nonatomic, readonly) BOOL isIndividual;
@property (nonatomic, readonly) BOOL isGroup;
@property (nonatomic, readonly) BOOL isReal;
@property (nonatomic, readonly) BOOL isFictional;

@end


@interface MHContributor (Fetching)

- (PMKPromise*)fetchMedia;

- (PMKPromise*)fetchMediaForced:(BOOL)forced
                       priority:(AVENetworkPriority*)priority
                   networkToken:(AVENetworkToken*)networkToken;

@end


@interface MHRealIndividualContributor : MHContributor

@end


@interface MHRealGroupContributor : MHContributor

@end


@interface MHFictionalIndividualContributor : MHContributor

@end


@interface MHFictionalGroupContributor : MHContributor

@end

