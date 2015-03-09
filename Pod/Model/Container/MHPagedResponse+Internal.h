//
//  MHPagedResponse+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHPagedResponse.h"

typedef PMKPromise*(^MHPagedResponseFetchNextBlock)(NSString*);


@interface MHPagedResponse (Internal)

@property (copy, nonatomic) MHPagedResponseFetchNextBlock fetchNextOperation;

@end