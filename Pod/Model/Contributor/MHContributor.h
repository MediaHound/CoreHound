//
//  MHContributor.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"


/**
 * An MHContributor is an individual or group entity that in some way contributes to
 * a piece of content.
 * Contributors can be either Real or Fictional.
 * A real contributor helped create the piece of content.
 * A fictional contributor is a character or entity that is part of the content.
 */
@interface MHContributor : MHObject

/**
 * Whether the contributor is an individual.
 * E.g.: Batman, The Joker, Mick Jagger.
 */
@property (nonatomic, readonly) BOOL isIndividual;

/**
 * Whether the contributor represents a group entitiy.
 * E.g.: Shield, The Avengers, NBC, Paramount.
 */
@property (nonatomic, readonly) BOOL isGroup;

/**
 * Whether the contributor exists in the real world.
 * E.g.: Taylor Swift, NBC.
 */
@property (nonatomic, readonly) BOOL isReal;

/**
 * Whether the contributor is fictional and exists only in the creative
 * world of the content.
 * E.g.: Batman, Shield, Tyler Durden.
 */
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

