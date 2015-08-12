//
//  MHContributor.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"
#import "MHMetadata.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * An MHContributor is an individual or group entity that in some way contributes to
 * a piece of content.
 * Contributors can be either Real or Fictional.
 * A real contributor helped create the piece of content.
 * A fictional contributor is a character or entity that is part of the content.
 */
@interface MHContributor : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHContributorMetadata* metadata;

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

/**
 * Fetches all media that this contributor contributed to.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchMedia;

/**
 * Fetches all media that this contributor contributed to.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchMediaForced:(BOOL)forced
                       priority:(AVENetworkPriority*)priority
                   networkToken:(AVENetworkToken* __nullable)networkToken;

@end


/**
 * An MHRealIndividualContributor is an real individual that in some way contributes to
 * a piece of content.
 */
@interface MHRealIndividualContributor : MHContributor

@end


/**
 * An MHRealGroupContributor is real group entity that in some way contributes to
 * a piece of content.
 */
@interface MHRealGroupContributor : MHContributor

@end


/**
 * An MHFictionalIndividualContributor is an fictional individual that in some way contributes to
 * a piece of content.
 */
@interface MHFictionalIndividualContributor : MHContributor

@end


/**
 * An MHFictionalGroupContributor is a fictional group entity that in some way contributes to
 * a piece of content.
 */
@interface MHFictionalGroupContributor : MHContributor

@end

NS_ASSUME_NONNULL_END

