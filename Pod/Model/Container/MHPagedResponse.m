//
//  MHPagedResponse.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"

#import <AtSugar/AtSugar.h>
#import <objc/runtime.h>


@implementation MHPagingInfo

@end


@interface MHPagedResponse ()

@property (copy, nonatomic) MHPagedResponseFetchNextBlock fetchNextOperation;

@property (strong, atomic) MHPagedResponse<Ignore>* cachedNextResponse;

@end


@implementation MHPagedResponse

- (PMKPromise*)fetchNext
{
    id cachedResponse = self.cachedNextResponse;
    if (cachedResponse) {
        return [PMKPromise promiseWithValue:cachedResponse];
    }
    
    return self.fetchNextOperation(self.pagingInfo.next).thenInBackground(^(MHPagedResponse* response) {
        
        self.cachedNextResponse = response;
        
        return response;
    });
}

- (BOOL)hasMorePages
{
    return self.pagingInfo.next != nil;
}

@end
