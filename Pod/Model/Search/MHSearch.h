//
//  MHSearch.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <Avenue/Avenue.h>

#import "MHSearchScope.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * Perform searches against the entertainment graph.
 */
@interface MHSearch : NSObject

/**
 * Perform a search of entertainment content given a search term and a scope.
 * @param search The search term to search the entertainment graph for.
 * @param scope A search filter that can restrict the content type of results.
 *     Scopes can contain multiple filters. For example:
 *     ```
 *     [MHSearch fetchResultsForSearchTerm:@"lost" scope:MHSearchScopeMovie | MHSearchScopeShowSeries]
 *     ```
 * @return A promise which resolves with the MHPagedResponse.
 */
+ (AnyPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(MHSearchScope)scope;

/**
 * Perform a search of entertainment content given a search term and a scope.
 * @param search The search term to search the entertainment graph for.
 * @param scope A search filter that can restrict the content type of results.
 *     Scopes can contain multiple filters. For example:
 *     ```
 *     [MHSearch fetchResultsForSearchTerm:@"lost" scope:MHSearchScopeMovie | MHSearchScopeShowSeries]
 *     ```
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with the MHPagedResponse.
 */
+ (AnyPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(MHSearchScope)scope
                                priority:(nullable AVENetworkPriority*)priority
                            networkToken:(nullable AVENetworkToken*)networkToken;

@end

NS_ASSUME_NONNULL_END
