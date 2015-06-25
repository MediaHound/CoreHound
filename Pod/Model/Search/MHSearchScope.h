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
