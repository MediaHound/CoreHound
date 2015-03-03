//
//  MHHashtag.m
//  CoreHound
//
//  Created by Dustin Bachrach on 12/22/14.
//
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
    NSString* path = [NSString stringWithFormat:@"%@/lookup/%@", [self.class rootEndpoint], name];
    return [[MHFetcher sharedFetcher] fetchModel:MHHashtag.class
                                            path:path
                                         keyPath:nil
                                      parameters:nil
                                        priority:priority
                                    networkToken:networkToken];
}

@end