//
//  MHHashtag.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"
#import "MHMetadata.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * An MHHashtag is a mentionable topic in the form "#name".
 */
@interface MHHashtag : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHHashtagMetadata* metadata;

@end


@interface MHHashtag (Fetching)

/**
 * Fetches a hashtag by it's name.
 * @param name The name of the hashtag, which does not include the '#'
 * @return A promise which resolves with the MHHashtag.
 */
+ (AnyPromise*)fetchByName:(NSString*)name;

/**
 * Fetches a hashtag by it's name.
 * @param name The name of the hashtag, which does not include the '#'
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with the MHHashtag.
 */
+ (AnyPromise*)fetchByName:(NSString*)name
                  priority:(nullable AVENetworkPriority*)priority
              networkToken:(nullable AVENetworkToken*)networkToken;

@end

NS_ASSUME_NONNULL_END
