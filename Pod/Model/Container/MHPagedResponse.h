//
//  MHPagedResponse.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <PromiseKit/PromiseKit.h>
#import "MHRelationalPair.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * An MHPagedResponse represents the result of requesting a single page.
 * It contains the contents of that page along with the ability to fetch
 * the next page of results.
 */
@interface MHPagedResponse : JSONModel

/**
 * An array of MHRelationalPairs that represent the content.
 * This array contains a single page of content.
 * To get the rest of the content use `fetchNext`.
 */
@property (strong, nonatomic) NSArray* content;

/**
 * Whether this paged response has more pages beyond this one.
 */
@property (nonatomic, readonly) BOOL hasMorePages;

/**
 * Fetch the next page of results.
 * Returns a promise that resolves with an MHPagedResponse.
 */
- (AnyPromise*)fetchNext;

@end

NS_ASSUME_NONNULL_END
