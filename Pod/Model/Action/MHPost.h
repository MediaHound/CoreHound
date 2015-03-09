//
//  MHPost.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHAction.h"


@interface MHPost : MHAction

+ (PMKPromise*)createWithMessage:(NSString*)message
                     mentions:(NSArray*)mentions
                  primaryMention:(MHObject*)primaryMention;

@end
