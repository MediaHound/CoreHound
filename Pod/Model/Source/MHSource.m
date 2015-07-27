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
#import "MHSourcePreference+Internal.h"

//#import <AgnosticLogger/AgnosticLogger.h>

NSString* const MHObjectActionParameterPreferenceKey = @"preference";

static NSString* const kAllRootSubendpoint = @"all";


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

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(subscriptions))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(allMediums))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

+ (NSString*)protocolForArrayProperty:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(subscriptions))]) {
        return NSStringFromClass(MHSubscription.class);
    }
    return [super protocolForArrayProperty:propertyName];
}

- (AnyPromise*)connect
{
    return [self takeAction:@"connect"
                 parameters:@{} // TODO: This is ugly. we shouldn't have to pass {}
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userConnected = @YES;
           return newSocial;
       }];
}

- (AnyPromise*)connectWithPreference:(MHSourcePreference)preference
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

- (AnyPromise*)connectWithPreference:(MHSourcePreference)preference description:(NSString*)description
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

- (AnyPromise*)disconnect
{
    return [self takeAction:@"disconnect"
                 parameters:@{} // TODO: This is ugly. we shouldn't have to pass {}
       predictedSocialBlock:^MHSocial* (MHSocial* oldSocial, NSDictionary* parameters) {
           MHSocial* newSocial = oldSocial.copy;
           newSocial.userConnected = @NO;
           return newSocial;
       }];
}

- (AnyPromise*)updatePreference:(MHSourcePreference)preference
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

- (AnyPromise*)updateDescription:(NSString*)description;
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
    [self invalidateRootCacheForEndpoint:[self rootSubendpoint:kAllRootSubendpoint]
                              parameters:nil];
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

+ (AnyPromise*)fetchAll
{
    return [self fetchAllForced:NO
                       priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                   networkToken:nil];
}

+ (AnyPromise*)fetchAllForced:(BOOL)forced
                     priority:(AVENetworkPriority*)priority
                 networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchRootPagedEndpoint:[self rootSubendpoint:kAllRootSubendpoint]
                                 forced:forced
                             parameters:nil
                               priority:priority
                           networkToken:networkToken
                                   next:nil];
}

@end
