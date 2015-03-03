//
//  MHSearch.m
//  CoreHound
//
//  Created by Dustin Bachrach on 2/26/15.
//
//

#import "MHSearch.h"
#import "MHFetcher.h"
#import "MHObject+Internal.h"

#import <AtSugar/AtSugar.h>

BOOL NSStringIsWhiteSpace(NSString* str)
{
    return ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0);
}

NSString* NSStringByAddingExtendedPercentEscapes(NSString* str)
{
    // For reference: http://mikeabdullah.net/escaping-url-paths-in-cocoa.html
    // and: http://iosdevelopertips.com/networking/url-encoding-method-in-objective-c.html
    return (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)str,
                                                                                 NULL,
                                                                                 (CFStringRef)@";/?:@&=$+{}<>,",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}


@implementation MHSearch

+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(NSString*)scope
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchResultsForSearchTerm:search
                                     scope:scope
                                  priority:priority
                              networkToken:networkToken
                                      next:nil];
}

+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(NSString*)scope
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken
                                    next:(NSString*)next
{
    if (search.length < 1 || NSStringIsWhiteSpace(search)) {
        MHPagedSearchResponse* response = [[MHPagedSearchResponse alloc] initWithDictionary:@{@"content":@[], @"number": @0, @"totalPages": @0} error:nil];
        return [PMKPromise promiseWithValue:response];
    }
    NSString* path = [NSString stringWithFormat:@"search/%@/%@", NSStringByAddingExtendedPercentEscapes(scope), NSStringByAddingExtendedPercentEscapes(search)];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"page.size"] = @(MHInternal_DefaultPageSize);
    if (next) {
        parameters[@"pageNext"] = next;
        // TODO: Remove
        parameters[@"page"] = next;
    }
    
    @weakSelf()
    return [[MHFetcher sharedFetcher] fetchModel:MHPagedSearchResponse.class
                                            path:path
                                         keyPath:nil
                                      parameters:parameters
                                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                    networkToken:networkToken].thenInBackground(^(MHPagedSearchResponse* pagedResponse) {
        pagedResponse.fetchNextOperation = ^(NSString* newNext) {
            return [weakSelf fetchResultsForSearchTerm:search
                                                 scope:scope
                                              priority:priority
                                          networkToken:nil
                                                  next:newNext];
        };
        for (AutocompleteResult* result in pagedResponse.content) {
            result.searchTerm = search;
        }
        return pagedResponse;
    });
}

@end


@implementation MHPagedSearchResponse
                  
- (BOOL)hasMorePages
{
    return self.number.integerValue + 1 < self.totalPages.integerValue;
}
                  
- (PMKPromise*)fetchNext
{
    // TODO:
    //    return self.fetchNextOperation(self.pagingInfo.next);
    return self.fetchNextOperation(@(self.number.integerValue + 1).stringValue);
}
                  
@end

