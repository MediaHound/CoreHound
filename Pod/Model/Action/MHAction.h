//
//  MHAction.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"

@class MHUser;


/**
 * An MHAction is an action that occurs in the MediaHound Graph.
 */
@interface MHAction : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHActionMetadata* metadata;

@property (strong, atomic) MHObject* primaryMention;
@property (strong, atomic) MHUser* primaryOwner;

@end
