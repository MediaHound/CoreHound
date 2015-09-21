//
//  MHPagingInfo.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * Represents information about the current page of a MHPagedResponse.
 */
@interface MHPagingInfo : JSONModel

/**
 * If there is a next page, then the `next` property is an opaque identifier
 * that can be used to fetch the next page.
 * If this is the last page, then the `next` property is nil.
 */
@property (strong, nullable, nonatomic) NSString* next;

@end

NS_ASSUME_NONNULL_END
