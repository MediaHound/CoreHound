//
//  MHPost.m
//  mediaHound
//
//  Created by Dustin Bachrach on 6/10/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHPost.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"
#import "MHMetadata.h"

#import <Avenue/AVENetworkManager.h>


@implementation MHPost

@declare_class_property (mhidPrefix, @"mhpst")

+ (void)load
{
    [self registerMHObject];
}

+ (PMKPromise*)createWithMessage:(NSString*)message
                        mentions:(NSArray*)mentions
                  primaryMention:(MHObject*)primaryMention
{
    NSMutableArray* mentionedMhids = [NSMutableArray array];
    for (MHObject* object in mentions) {
        [mentionedMhids addObject:object.metadata.mhid];
    }
    
    // TODO: MHFetcher should handle this and do it with POST
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:@"new"]
                                       parameters:@{
                                                    @"message": message,
                                                    @"mentions": mentionedMhids,
                                                    @"primaryMention": primaryMention.metadata.mhid
                                                    }
                                      networkToken:nil
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]

                                           builder:[MHFetcher sharedFetcher].builder].thenInBackground(^(id result) {
        // All mentioned content should update social data becaise it's mentioned count has changed
        for (MHObject* object in mentions) {
            [object fetchSocialForced:YES
                             priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh]
                         networkToken:nil];
        }
        return result;
    });
    // TODO: Should we check response?
}

@end
