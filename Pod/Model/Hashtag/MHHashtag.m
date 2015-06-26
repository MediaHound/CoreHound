//
//  MHHashtag.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHHashtag.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"


@implementation MHHashtag

@declare_class_property (rootEndpoint, @"graph/hashtag")

@declare_class_property (mhidPrefix, @"mhhtg")

+ (void)load
{
    [self registerMHObject];
}

@end


@implementation MHHashtag (Fetching)

+ (PMKPromise*)fetchByName:(NSString*)name
{
    return [self fetchByName:name
                    priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                networkToken:nil];
}

+ (PMKPromise*)fetchByName:(NSString*)name
                  priority:(AVENetworkPriority*)priority
              networkToken:(AVENetworkToken*)networkToken
{
    return [[MHFetcher sharedFetcher] fetchModel:MHHashtag.class
                                            path:[self rootSubendpointByLookup:name]
                                         keyPath:nil
                                      parameters:nil
                                        priority:priority
                                    networkToken:networkToken];
}

@end