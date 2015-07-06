//
//  MHSubscription.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"


/**
 * An MHSubscription is a bundling of content that a user can pay for
 * to consume media.
 */
@interface MHSubscription : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHSubscriptionMetadata* metadata;

/**
 * A user-displayable price for the subscription.
 */
@property (strong, nonatomic, readonly) NSString* displayPrice;

@end