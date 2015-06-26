//
//  MHPagedResponse.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"
#import "MHPagingInfo.h"


@interface MHPagedResponse ()

/**
 * Information about this page and subsequent pages.
 * You should not typically need to access the data.
 */
@property (strong, nonatomic) MHPagingInfo<Optional>* pagingInfo; // TODO: Remove optionality

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
    return (self.pagingInfo.next != nil);
}

@end


@implementation MHPagedResponse (Internal)

+ (instancetype)emptyPagedResponse
{
    MHPagedResponse* response = [[MHPagedResponse alloc] init];
    response.content = (NSArray<MHRelationalPair>*) @[];
    response.pagingInfo = [[MHPagingInfo alloc] init];
    return response;
}

@end
