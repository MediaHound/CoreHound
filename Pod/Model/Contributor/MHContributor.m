//
//  MHContributor.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHContributor.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"
#import "MHPagedResponse.h"


@interface MHContributor ()

@end


@implementation MHContributor

@declare_class_property (rootEndpoint, @"graph/contributor")

- (BOOL)isGroup
{
    return !self.isIndividual;
}

- (BOOL)isFictional
{
    return !self.isReal;
}

@end


@implementation MHContributor (Fetching)

- (PMKPromise*)fetchMedia
{
    return [self fetchMediaForced:NO
                         priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                     networkToken:nil];
}

- (PMKPromise*)fetchMediaForced:(BOOL)forced
                       priority:(AVENetworkPriority*)priority
                   networkToken:(AVENetworkToken*)networkToken
{
    return [self fetchPagedEndpoint:[self subendpoint:@"media"]
                             forced:forced
                           priority:priority
                       networkToken:networkToken
                               next:nil];
}

@end


@implementation MHRealIndividualContributor

@declare_class_property (mhidPrefix, @"mhric")

+ (void)load
{
    [self registerMHObject];
}

- (BOOL)isIndividual
{
    return YES;
}

- (BOOL)isReal
{
    return YES;
}

@end


@implementation MHRealGroupContributor

@declare_class_property (mhidPrefix, @"mhrgc")

+ (void)load
{
    [self registerMHObject];
}

- (BOOL)isIndividual
{
    return NO;
}

- (BOOL)isReal
{
    return YES;
}

@end


@implementation MHFictionalIndividualContributor

@declare_class_property (mhidPrefix, @"mhfic")

+ (void)load
{
    [self registerMHObject];
}

- (BOOL)isIndividual
{
    return YES;
}

- (BOOL)isReal
{
    return NO;
}

@end


@implementation MHFictionalGroupContributor

@declare_class_property (mhidPrefix, @"mhfgc")

+ (void)load
{
    [self registerMHObject];
}

- (BOOL)isIndividual
{
    return NO;
}

- (BOOL)isReal
{
    return NO;
}

@end
