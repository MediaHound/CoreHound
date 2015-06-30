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
@property (strong, nonatomic) MHPagingInfo* pagingInfo;

@property (copy, nonatomic) MHPagedResponseFetchNextBlock fetchNextOperation;

@property (strong, atomic) MHPagedResponse* cachedNextResponse;

@end


@implementation MHPagedResponse

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(cachedNextResponse))]) {
        return YES;
    }
    return [super propertyIsIgnored:propertyName];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    // TODO: Remove optionality for pagingInfo
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(pagingInfo))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

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
