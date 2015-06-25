//
//  MHPagedResponse.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <PromiseKit/PromiseKit.h>
#import "MHRelationalPair.h"

@class MHPagingInfo;


/**
 * An MHPagedResponse represents the result of requesting a single page.
 * It contains the contents of that page along with the ability to fetch
 * the next page of results.
 */
@interface MHPagedResponse : JSONModel

/**
 * An array of relational pairs that represent the content.
 * This array contains a single page of content.
 * To get the rest of the content use `fetchNext`.
 */
@property (strong, nonatomic) NSArray<MHRelationalPair>* content;

/**
 * Information about this page and subsequent pages.
 * You should not typically need to access the data.
 */
@property (strong, nonatomic) MHPagingInfo<Optional>* pagingInfo; // TODO: Remove optionality

/**
 * Whether this paged response has more pages beyond this one.
 */
@property (nonatomic, readonly) BOOL hasMorePages;

/**
 * Fetch the next page of results.
 * Returns a promise that resolves with an MHPagedResponse.
 */
- (PMKPromise*)fetchNext;

@end
