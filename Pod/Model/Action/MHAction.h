//
//  MHAction.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"

@class MHUser;

NS_ASSUME_NONNULL_BEGIN


/**
 * An MHAction is an action that occurs in the MediaHound Graph.
 */
@interface MHAction : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHActionMetadata* metadata;

@property (strong, atomic) MHObject* __nullable primaryMention;
@property (strong, atomic) MHUser* __nullable primaryOwner;

@end

NS_ASSUME_NONNULL_END
