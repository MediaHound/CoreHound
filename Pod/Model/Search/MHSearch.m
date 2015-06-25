//
//  MHSearch.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSearch.h"
#import "MHSearchScope+Internal.h"
#import "MHFetcher.h"
#import "MHObject+Internal.h"
#import "MHPagedResponse.h"
#import "MHPagedResponse+Internal.h"

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
                                   scope:(MHSearchScope)scope
{
    return [self fetchResultsForSearchTerm:search
                                     scope:scope
                                  priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                              networkToken:nil];
}

+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(MHSearchScope)scope
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
                                   scope:(MHSearchScope)scope
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken
                                    next:(NSString*)next
{
    if (search.length < 1 || NSStringIsWhiteSpace(search)) {
        MHPagedResponse* response = [[MHPagedResponse alloc] initWithDictionary:@{
                                                                                  @"content":@[],
                                                                                  @"pagingInfo": [[MHPagingInfo alloc] initWithDictionary:@{} error:nil]
                                                                                  }
                                                                          error:nil];
        return [PMKPromise promiseWithValue:response];
    }
    NSString* scopeString = NSStringFromMHSearchScope(scope);
    NSString* path = [NSString stringWithFormat:@"search/%@/%@", NSStringByAddingExtendedPercentEscapes(scopeString), NSStringByAddingExtendedPercentEscapes(search)];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"pageSize"] = @(MHInternal_DefaultPageSize);
    if (next) {
        parameters[@"next"] = next;
    }
    
    @weakSelf()
    return [[MHFetcher sharedFetcher] fetchModel:MHPagedResponse.class
                                            path:path
                                         keyPath:nil
                                      parameters:parameters
                                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                    networkToken:networkToken].thenInBackground(^(MHPagedResponse* pagedResponse) {
        pagedResponse.fetchNextOperation = ^(NSString* newNext) {
            return [weakSelf fetchResultsForSearchTerm:search
                                                 scope:scope
                                              priority:priority
                                          networkToken:nil
                                                  next:newNext];
        };
//        for (AutocompleteResult* result in pagedResponse.content) {
//            result.searchTerm = search;
//        }
        return pagedResponse;
    });
}

@end
