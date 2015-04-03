//
//  MHAction.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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

@property (strong, atomic) MHObject<Optional>* primaryMention;
@property (strong, atomic) MHUser<Optional>* primaryOwner;

@end
