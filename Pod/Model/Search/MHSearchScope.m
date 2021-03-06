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
    if (scope != MHSearchScopeAll) {
        if (scope & MHSearchScopeMovie) {
            [set addObject:@"movie"];
        }
        if (scope & MHSearchScopeTrack) {
            [set addObject:@"track"];
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
    
    return set;
}
