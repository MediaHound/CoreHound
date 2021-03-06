//
//  MHPost.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHPost.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"

#import <Avenue/AVENetworkManager.h>


@implementation MHPost

@declare_class_property (mhidPrefix, @"mhpst")

+ (void)load
{
    [self registerMHObject];
}

+ (AnyPromise*)createWithMessage:(NSString*)message
                        mentions:(NSArray*)mentions
                  primaryMention:(MHObject*)primaryMention
{
    NSMutableArray* mentionedMhids = [NSMutableArray array];
    for (MHObject* object in mentions) {
        [mentionedMhids addObject:object.metadata.mhid];
    }
    
    // TODO: MHFetcher should handle this and do it with POST
    return [[AVENetworkManager sharedManager] POST:[self rootSubendpoint:kCreateRootSubendpoint]
                                       parameters:@{
                                                    @"message": message,
                                                    @"mentions": mentionedMhids,
                                                    @"primaryMention": primaryMention.metadata.mhid
                                                    }
                                          priority:nil
                                      networkToken:nil
                                           builder:[MHFetcher sharedFetcher].builder].thenInBackground(^(id result) {
        // All mentioned content should update social data becaise it's mentioned count has changed
        for (MHObject* object in mentions) {
            [object fetchSocialForced:YES
                             priority:nil
                         networkToken:nil];
        }
        return result;
    });
    // TODO: Should we check response?
}

@end
