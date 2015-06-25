//
//  MHSource.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSource.h"
#import "MHSocial.h"
#import "MHFetcher.h"
#import "MHPagedResponse.h"
#import "MHObject+Internal.h"
#import "MHLoginSession.h"

//#import <AgnosticLogger/AgnosticLogger.h>

NSString* const MHObjectActionParameterPreferenceKey = @"preference";

static MHPagedResponse* s_allSources = nil;


@implementation MHSource

@dynamic metadata;

+ (void)load
{
    [self registerMHObject];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogout:)
                                                 name:MHLoginSessionUserDidLogoutNotification
                                               object:nil];
}

@declare_class_property (mhidPrefix, @"mhsrc")
@declare_class_property (rootEndpoint, @"graph/source")

- (PMKPromise*)connect
{
    return [self takeAction:@"connect"
                 parameters:@{} // TODO: This is ugly. we shouldn't have to pass {}
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userConnected = @YES;
           return newSocial;
       }];
}

- (PMKPromise*)connectWithPreference:(MHSourcePreference)preference
{
    return [self takeAction:@"connect"
                 parameters:@{
                              MHObjectActionParameterPreferenceKey: NSStringFromMHSourcePreference(preference)
                              }
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userConnected = @YES;
           newSocial.userPreference = preference;
           return newSocial;
       }];
}

- (PMKPromise*)connectWithPreference:(MHSourcePreference)preference description:(NSString*)description
{
    return [self takeAction:@"connect"
                 parameters:@{
                              MHObjectActionParameterPreferenceKey: NSStringFromMHSourcePreference(preference),
                              @"description": description
                              }
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userConnected = @YES;
           newSocial.userPreference = preference;
           newSocial.userSourceDescription = description;
           return newSocial;
       }];
}

- (PMKPromise*)disconnect
{
    return [self takeAction:@"disconnect"
                 parameters:@{} // TODO: This is ugly. we shouldn't have to pass {}
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userConnected = @NO;
           return newSocial;
       }];
}

- (PMKPromise*)updatePreference:(MHSourcePreference)preference
{
    return [self takeAction:@"update"
                 parameters:@{
                              MHObjectActionParameterPreferenceKey: NSStringFromMHSourcePreference(preference)
                              }
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userPreference = preference;
           return newSocial;
       }];
}

- (PMKPromise*)updateDescription:(NSString*)description;
{
    return [self takeAction:@"update"
                 parameters:@{
                              @"description": description
                              }
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userSourceDescription = description;
           return newSocial;
       }];
}

#pragma mark - Notifications

+ (void)userDidLogout:(NSNotification*)notification
{
    s_allSources = nil;
}

#pragma mark - Source Checks

- (BOOL)isITunes
{
    return [self hasMhid:@"mhsrcRcTZuZn9N3OXfGnEDR8TkfzXG9BT6OIUAqQAXqg"];
}

- (BOOL)isRdio
{
    return [self hasMhid:@"mhsrc5ibLEbTVKtRmdvvVqb4n0Eln3siC3b6h1yy3gHC"];
}

- (BOOL)isSpotify
{
    return [self hasMhid:@"mhsrcGZoIwIOwV3DuhjaoBzDvR48uvTTZlNg3vAHQlJ3"];
}

- (BOOL)isNetflix
{
    return [self hasMhid:@"mhsrcwRw33Yek3hvzTpbqzT7hL9EOAeyec7Y61npmukm"];
}

- (BOOL)isHulu
{
    return [self hasMhid:@"mhsrcDINVH54l93akNjR0oiND5Hegf9uChAGRAoxUyTN"];
}

@end


@implementation MHSource (Fetching)

+ (PMKPromise*)fetchAll
{
    return [self fetchAllForced:NO
                       priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                   networkToken:nil];
}

+ (PMKPromise*)fetchAllForced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken
{
    if (!forced) {
        @synchronized (self) {
            if (s_allSources) {
                return [PMKPromise promiseWithValue:s_allSources];
            }
        }
    }
    
    return [[MHFetcher sharedFetcher] fetchModel:MHPagedResponse.class
                                            path:[self rootSubendpoint:@"all"]
                                         keyPath:nil
                                      parameters:@{
                                                   MHFetchParameterView: MHFetchParameterViewFull
                                                   }
                                        priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                                    networkToken:nil].thenInBackground(^(MHPagedResponse* response) {
        @synchronized (self) {
            s_allSources = response;
        }
        
        return response;
    });
}

@end
