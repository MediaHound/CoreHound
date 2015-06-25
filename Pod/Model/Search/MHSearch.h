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


/**
 * Perform searches against the entertainment graph.
 */
@interface MHSearch : NSObject

/**
 * Perform a search of entertainment content given a search term and a scope.
 * @param search The search term to search the entertainment graph for.
 * @param scope A search filter that can restrict the content type of results.
 * @return A promise which resolves with the MHPagedResponse.
 */
+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(MHSearchScope)scope;

/**
 * Perform a search of entertainment content given a search term and a scope.
 * @param search The search term to search the entertainment graph for.
 * @param scope A search filter that can restrict the content type of results.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with the MHPagedResponse.
 */
+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(MHSearchScope)scope
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken;

@end
