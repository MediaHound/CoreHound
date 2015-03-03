//
//  MHPeriodicalSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHPeriodicalSeries.h"
#import "MHObject+Internal.h"


@implementation MHPeriodicalSeries

@declare_class_property (mhidPrefix, @"mhpds")

+ (void)load
{
    [self registerMHObject];
}

@end
