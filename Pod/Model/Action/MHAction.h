//
//  Post.h
//  MediaHound
//
//  Created by Tai Bo on 11/20/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHObject.h"

@class MHUser;
@class MHActionMetadata;


/**
 * The model which represents a Post
 */
@interface MHAction : MHObject

@property (strong, nonatomic) MHActionMetadata* metadata;

@property (strong, atomic) MHObject<Optional>* primaryMention;
@property (strong, atomic) MHUser<Optional>* primaryOwner;

@end
