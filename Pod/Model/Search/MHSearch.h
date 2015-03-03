//
//  MHSearch.h
//  CoreHound
//
//  Created by Dustin Bachrach on 2/26/15.
//
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <Avenue/Avenue.h>
#import "AutocompleteResult.h"

@class MHPagingInfo;

/**
 * Search scopes filter what type of content is returned from search.
 * If you do not want to filter by content type, use `MHSearchScopeAll`.
 */
typedef NS_ENUM(NSInteger, MHSearchScope) {
    /**
     * Do not filter by content type. Return all results.
     */
    MHSearchScopeAll,
    
    /**
     * Only return Movie results.
     */
    MHSearchScopeMovie,
    
    /**
     * Only return Song results.
     */
    MHSearchScopeSong,
    
    /**
     * Only return Album results.
     */
    MHSearchScopeAlbum,
    
    /**
     * Only return TV Series results.
     */
    MHSearchScopeTvSeries,
    
    /**
     * Only return TV Season results.
     */
    MHSearchScopeTvSeason,
    
    /**
     * Only return TV Episode results.
     */
    MHSearchScopeTvEpisode,
    
    /**
     * Only return Book results.
     */
    MHSearchScopeBook,
    
    /**
     * Only return Game results.
     */
    MHSearchScopeGame,
    
    /**
     * Only return Collection results.
     */
    MHSearchScopeCollection,
    
    /**
     * Only return User results.
     */
    MHSearchScopeUser,
    
    /**
     * Only return Contributor results.
     */
    MHSearchScopeContributor
};


/**
 * Perform searches against the entertainment graph.
 */
@interface MHSearch : NSObject

/**
 * Perform a search of entertainment content given a search term and a scope.
 * @param search The search term to search the entertainment graph for.
 * @param scope A search filter that can restrict the content type of results.
 * @return A promise which resolves with the MHPagedSearchResponse.
 */
+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(MHSearchScope)scope;

/**
 * Perform a search of entertainment content given a search term and a scope.
 * @param search The search term to search the entertainment graph for.
 * @param scope A search filter that can restrict the content type of results.
 * @param priority The network request priority.
 * @param networkToken The token for the network request, allowing cancelation and re-prioritization.
 * @return A promise which resolves with the MHPagedSearchResponse.
 */
+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(MHSearchScope)scope
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken;

@end


typedef PMKPromise*(^MHPagedSearchResponseFetchNextBlock)(NSString*);


// Would be nice to have this use MHPagedResponse
// In mh, extend this with protocol: MHRequesterPagedResponse
@interface MHPagedSearchResponse : JSONModel

@property (strong, nonatomic) NSArray<AutocompleteResult>* content;
@property (strong, nonatomic) MHPagingInfo<Optional>* pagingInfo;
@property (strong, nonatomic) NSNumber* number;
@property (strong, nonatomic) NSNumber* totalPages;
@property (nonatomic, readonly) BOOL hasMorePages;

// TODO: Internal
@property (copy, nonatomic) MHPagedSearchResponseFetchNextBlock fetchNextOperation;

- (PMKPromise*)fetchNext;

@end
