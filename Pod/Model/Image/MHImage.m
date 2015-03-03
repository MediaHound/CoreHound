//
//  MHImage.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/2/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHImage.h"
#import "MHObject+Internal.h"


@implementation MHImage

@declare_class_property (mhidPrefix, @"mhimg")
@declare_class_property (rootEndpoint, @"graph/image")

+ (void)load
{
    [self registerMHObject];
}

@end
