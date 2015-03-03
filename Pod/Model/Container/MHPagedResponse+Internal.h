//
//  MHPagedResponse+Internal.h
//  CoreHound
//
//  Created by Dustin Bachrach on 12/30/14.
//
//

#import "MHPagedResponse.h"

typedef PMKPromise*(^MHPagedResponseFetchNextBlock)(NSString*);


@interface MHPagedResponse (Internal)

@property (copy, nonatomic) MHPagedResponseFetchNextBlock fetchNextOperation;

@end