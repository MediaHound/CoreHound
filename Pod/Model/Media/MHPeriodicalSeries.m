//
//  MHPeriodicalSeries.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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
