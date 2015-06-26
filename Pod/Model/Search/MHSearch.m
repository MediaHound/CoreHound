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
#import "MHContext.h"

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
        MHPagedResponse* response = [MHPagedResponse emptyPagedResponse];
        return [PMKPromise promiseWithValue:response];
    }
    
    NSSet* scopes = ScopeStringsFromMHSearchScope(scope);
    NSString* path = [NSString stringWithFormat:@"search/all/%@", NSStringByAddingExtendedPercentEscapes(search)];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[MHFetchParameterPageSize] = @(MHInternal_DefaultPageSize);
    parameters[@"types"] = scopes;
    
    if (next) {
        parameters[MHFetchParameterNext] = next;
    }
    
    // TODO: Remove this after v=2 is no longer needed
    parameters[@"v"] = @"2";
    
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
        for (MHRelationalPair* pair in pagedResponse.content) {
            MHContext* context = pair.context;
            context.searchTerm = search;
            context.searchScope = scope;
        }
        return pagedResponse;
    });
}

@end
