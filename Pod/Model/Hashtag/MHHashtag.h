//
//  MHHashtag.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"


/**
 * An MHHashtag is a mentionable topic in the form "#name".
 */
@interface MHHashtag : MHObject

@end


@interface MHHashtag (Fetching)

/**
 * Fetches a hashtag by it's name.
 * @param name The name of the hashtag, which does not include the '#'
 * @return A promise which resolves with the MHHashtag.
 */
+ (PMKPromise*)fetchByName:(NSString*)name;

/**
 * Fetches a hashtag by it's name.
 * @param name The name of the hashtag, which does not include the '#'
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with the MHHashtag.
 */
+ (PMKPromise*)fetchByName:(NSString*)name
                  priority:(AVENetworkPriority*)priority
              networkToken:(AVENetworkToken*)networkToken;

@end
