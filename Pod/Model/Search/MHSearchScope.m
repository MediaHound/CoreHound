//
//  MHSearchScope.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHSearchScope.h"

NSSet * ScopeStringsFromMHSearchScope(MHSearchScope scope)
{
    NSMutableSet* set = [NSMutableSet set];
    if (scope == MHSearchScopeAll) {
        [set addObject:@"all"];
    }
    else {
        if (scope & MHSearchScopeMovie) {
            [set addObject:@"movie"];
        }
        if (scope & MHSearchScopeSong) {
            [set addObject:@"song"];
        }
        if (scope & MHSearchScopeAlbum) {
            [set addObject:@"album"];
        }
        if (scope & MHSearchScopeShowSeries) {
            [set addObject:@"showseries"];
        }
        if (scope & MHSearchScopeShowSeason) {
            [set addObject:@"showseason"];
        }
        if (scope & MHSearchScopeShowEpisode) {
            [set addObject:@"showepisode"];
        }
        if (scope & MHSearchScopeBook) {
            [set addObject:@"book"];
        }
        if (scope & MHSearchScopeGame) {
            [set addObject:@"game"];
        }
        if (scope & MHSearchScopeCollection) {
            [set addObject:@"collection"];
        }
        if (scope & MHSearchScopeUser) {
            [set addObject:@"user"];
        }
        if (scope & MHSearchScopeContributor) {
            [set addObject:@"contributor"];
        }
    }
    
    // If nothing was found, fall back on all
    if (set.count == 0) {
        [set addObject:@"all"];
    }
    
    return set;
}
