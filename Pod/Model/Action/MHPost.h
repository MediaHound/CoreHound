//
//  MHPost.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAction.h"


/**
 * An MHPost action occurs when a user creates a post.
 */
@interface MHPost : MHAction

/**
 * Creates a post with a message mentioning content.
 * @param message The user's written message
 * @param mentions A list of mentioned content. The user must mention at least one thing.
 * @param primaryMention The primary mention that the user is posting about.
 * @return A promise which resolves when the message is created.
 */
+ (PMKPromise*)createWithMessage:(NSString*)message
                        mentions:(NSArray*)mentions
                  primaryMention:(MHObject*)primaryMention;

@end
