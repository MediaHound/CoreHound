//
//  MHCollection.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"

@class MHUser;


/**
 * A collection is a user-created grouping of MHObjects.
 * Collections can contain multiple content types, so users can collect movies, tracks, books, etc
 * all into a single collection.
 */
@interface MHCollection : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHCollectionMetadata* metadata;

/**
 * The primary owner is the user who created the collection.
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchPrimaryOwner to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, atomic) MHUser* primaryOwner;

/**
 * The firstContentImage is the MHImage of the first piece of content in this collection.
 * This property may be unrealized. You should rarely access it directly.
 * You need to call -fetchFirstContentImage to ensure it has been loaded.
 * This property is KVO compliant.
 */
@property (strong, atomic) MHImage* firstContentImage;

/**
 * Add a single MHObject to this collection.
 * @param content The new piece of content to add to this collection
 * @return A promise which resolves when the content has succesfully been added
 */
- (AnyPromise*)addContent:(MHObject*)content;

/**
 * Add multiple MHObjects to this collection.
 * @param contents The new pieces of content to add to this collection
 * @return A promise which resolves when the content has succesfully been added
 */
- (AnyPromise*)addContents:(NSArray*)contents;

/**
 * Remove a single MHObject from this collection.
 * @param content The piece of content to remove from this collection
 * @return A promise which resolves when the content has succesfully been removed
 */
- (AnyPromise*)removeContent:(MHObject*)content;

/**
 * Remove multiple MHObjects from this collection.
 * @param contents The pieces of content to remove from this collection
 * @return A promise which resolves when the content has succesfully been removed
 */
- (AnyPromise*)removeContents:(NSArray*)contents;

/**
 * Rename this collection to the given name.
 * @param name The new name of the collection
 * @return A promise which resolves when the name has been changed
 */
- (AnyPromise*)setName:(NSString*)name;

@end


@interface MHCollection (Creating)

/**
 * Creates a new empty collection with a given name.
 * There must be a valid MHLoginSession with an authenticated user
 * to create a collection.
 * @param name The name of the collection to create
 * @return A promise which resolves with the newly created MHCollection
 */
+ (AnyPromise*)createWithName:(NSString*)name;

/**
 * Creates a new collection with a given name and an array of initial content.
 * There must be a valid MHLoginSession with an authenticated user
 * to create a collection.
 * @param name The name of the collection to create
 * @param initialContent an array of MHObjects to initially put into the collection
 * @return A promise which resolves with the newly created MHCollection.
 */
+ (AnyPromise*)createWithName:(NSString*)name initialContent:(NSArray*)initialContent;

@end


@interface MHCollection (Fetching)

/**
 * Fetches the collection's primary owner.
 * You should never read the `primaryOwner` property directly from an MHCollection.
 * Instead, always access the owner via the `fetchPrimaryOwner` promise. 
 * The `primaryOwner` property can be used for observing KVO changes.
 * @return A promise which resolves with an MHUser.
 */
- (AnyPromise*)fetchPrimaryOwner;

/**
 * Fetches the collection's primary owner.
 * You should never read the `primaryOwner` property directly from an MHCollection.
 * Instead, always access the owner via the `fetchPrimaryOwner` promise.
 * The `primaryOwner` property can be used for observing KVO changes.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHUser.
 */
- (AnyPromise*)fetchPrimaryOwnerForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches the image of the collection's first piece of content.
 * You should never read the `firstContentImage` property directly from an MHCollection.
 * Instead, always access the image via the `fetchFirstContentImage` promise.
 * The `firstContentImage` property can be used for observing KVO changes.
 * @return A promise which resolves with an MHImage.
 */
- (AnyPromise*)fetchFirstContentImage;

/**
 * Fetches the image of the collection's first piece of content.
 * You should never read the `firstContentImage` property directly from an MHCollection.
 * Instead, always access the image via the `fetchFirstContentImage` promise.
 * The `firstContentImage` property can be used for observing KVO changes.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHImage.
 */
- (AnyPromise*)fetchFirstContentImageForced:(BOOL)forced
                                   priority:(AVENetworkPriority*)priority
                               networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all of the owners of this collection.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchOwners;

/**
 * Fetches all of the owners of this collection.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchOwnersForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all content that is in the collection.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchContent;

/**
 * Fetches all content that is in the collection.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchContentForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

/**
 * Fetches all mixlist content that is in the collection.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchMixList;

/**
 * Fetches all mixlist content that is in the collection.
 * @param forced Whether to use a cached response. If YES, a network request will occur. If NO, a cached result may be used.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchMixListForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

@end
