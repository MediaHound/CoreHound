//
//  MHSearchScope.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHSearchScope.h"

NSString* NSStringFromMHSearchScope(MHSearchScope scope)
{
    NSDictionary* scopeString = @{
                                  @(MHSearchScopeAll):         @"all",
                                  @(MHSearchScopeMovie):       @"movie",
                                  @(MHSearchScopeSong):        @"song",
                                  @(MHSearchScopeAlbum):       @"album",
                                  @(MHSearchScopeTvSeries):    @"tvseries",
                                  @(MHSearchScopeTvSeason):    @"tvseason",
                                  @(MHSearchScopeTvEpisode):   @"tvepisode",
                                  @(MHSearchScopeBook):        @"book",
                                  @(MHSearchScopeGame):        @"game",
                                  @(MHSearchScopeCollection):  @"collection",
                                  @(MHSearchScopeUser):        @"user",
                                  @(MHSearchScopeContributor): @"person"
                                  };
    return scopeString[@(scope)];
}
