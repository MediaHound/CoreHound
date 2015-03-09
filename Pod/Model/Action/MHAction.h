//
//  MHAction.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHObject.h"

@class MHUser;


/**
 * The model which represents a Post
 */
@interface MHAction : MHObject

@property (strong, atomic) MHActionMetadata* metadata;

@property (strong, atomic) MHObject<Optional>* primaryMention;
@property (strong, atomic) MHUser<Optional>* primaryOwner;

@end
