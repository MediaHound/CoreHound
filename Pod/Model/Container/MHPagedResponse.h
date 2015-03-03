//
//  MHPagedResponse.h
//  mediaHound
//
//  Created by Dustin Bachrach on 6/25/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <PromiseKit/PromiseKit.h>
#import "MHRelationalPair.h"


@interface MHPagingInfo : JSONModel

@property (strong, nonatomic) NSString<Optional>* next;

@end


@interface MHPagedResponse : JSONModel

@property (strong, nonatomic) NSArray<MHRelationalPair>* content;
@property (strong, nonatomic) MHPagingInfo<Optional>* pagingInfo; // TODO: Remove optionality

@property (nonatomic, readonly) BOOL hasMorePages;

- (PMKPromise*)fetchNext;

@end
