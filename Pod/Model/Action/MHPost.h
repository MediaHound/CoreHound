//
//  MHPost.h
//  mediaHound
//
//  Created by Dustin Bachrach on 6/10/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHAction.h"


@interface MHPost : MHAction

+ (PMKPromise*)createWithMessage:(NSString*)message
                     mentions:(NSArray*)mentions
                  primaryMention:(MHObject*)primaryMention;

@end
