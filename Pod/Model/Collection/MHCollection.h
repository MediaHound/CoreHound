//
//  UserCollection.h
//  MediaHound
//
//  Created by Tai Bo on 7/19/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHMedia.h"

@class MHUser;


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
