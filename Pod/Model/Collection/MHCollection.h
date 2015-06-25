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
 * Collections can contain multiple content types, so users can collect movies, songs, and books
 * all into one collection.
 */
@interface MHCollection : MHObject

@property (strong, atomic) MHCollectionMetadata* metadata;

@property (strong, atomic) MHUser<Optional>* primaryOwner;

@property (strong, atomic) MHImage<Optional>* firstContentImage;

- (PMKPromise*)addContent:(MHObject*)content;

- (PMKPromise*)addContents:(NSArray*)content;

- (PMKPromise*)removeContent:(MHObject*)content;

- (PMKPromise*)removeContents:(NSArray*)contents;

- (PMKPromise*)setName:(NSString*)name;

@end


@interface MHCollection (Creating)

+ (PMKPromise*)createWithName:(NSString*)name;
+ (PMKPromise*)createWithName:(NSString*)name initialContent:(NSArray*)initialContent;

@end


@interface MHCollection (Fetching)

- (PMKPromise*)fetchPrimaryOwner;
- (PMKPromise*)fetchPrimaryOwnerForced:(BOOL)forced
                              priority:(AVENetworkPriority*)priority
                          networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchFirstContentImage;
- (PMKPromise*)fetchFirstContentImageForced:(BOOL)forced
                                   priority:(AVENetworkPriority*)priority
                               networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchOwners;

- (PMKPromise*)fetchOwnersForced:(BOOL)forced
                        priority:(AVENetworkPriority*)priority
                    networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchContent;

- (PMKPromise*)fetchContentForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

- (PMKPromise*)fetchMixList;

- (PMKPromise*)fetchMixListForced:(BOOL)forced
                         priority:(AVENetworkPriority*)priority
                     networkToken:(AVENetworkToken*)networkToken;

@end
