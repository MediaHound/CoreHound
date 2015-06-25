//
//  MHPagedResponse+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHPagedResponse.h"

typedef PMKPromise*(^MHPagedResponseFetchNextBlock)(NSString*);


@interface MHPagedResponse (Internal)

@property (copy, nonatomic) MHPagedResponseFetchNextBlock fetchNextOperation;

+ (instancetype)emptyPagedResponse;

@end