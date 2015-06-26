//
//  MHSearchScope.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
 * Search scopes filter what type of content is returned from search.
 * If you do not want to filter by content type, use `MHSearchScopeAll`.
 * Scopes can contain multiple filters. For example:
 *     ```
 *     [MHSearch fetchResultsForSearchTerm:@"lost" scope:MHSearchScopeMovie | MHSearchScopeShowSeries]
 *     ```
 */
typedef NS_ENUM(NSUInteger, MHSearchScope) {
    /**
     * Do not filter by content type. Return all results.
     */
    MHSearchScopeAll         = 0,
    
    /**
     * Only return Movie results.
     */
    MHSearchScopeMovie       = 1 << 0,
    
    /**
     * Only return Song results.
     */
    MHSearchScopeSong        = 1 << 1,
    
    /**
     * Only return Album results.
     */
    MHSearchScopeAlbum       = 1 << 2,
    
    /**
     * Only return Show Series results.
     */
    MHSearchScopeShowSeries  = 1 << 3,
    
    /**
     * Only return Show Season results.
     */
    MHSearchScopeShowSeason  = 1 << 4,
    
    /**
     * Only return Show Episode results.
     */
    MHSearchScopeShowEpisode = 1 << 5,
    
    /**
     * Only return Book results.
     */
    MHSearchScopeBook        = 1 << 6,
    
    /**
     * Only return Game results.
     */
    MHSearchScopeGame        = 1 << 7,
    
    /**
     * Only return Collection results.
     */
    MHSearchScopeCollection  = 1 << 8,
    
    /**
     * Only return User results.
     */
    MHSearchScopeUser        = 1 << 9,
    
    /**
     * Only return Contributor results.
     */
    MHSearchScopeContributor = 1 << 10
};
