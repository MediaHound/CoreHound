//
//  MHGraphicNovelSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHGraphicNovelSeries.h"
#import "MHObject+Internal.h"


@implementation MHGraphicNovelSeries

@declare_class_property (mhidPrefix, @"mhgns")

+ (void)load
{
    [self registerMHObject];
}

@end
