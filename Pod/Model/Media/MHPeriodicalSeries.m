//
//  MHPeriodicalSeries.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHPeriodicalSeries.h"
#import "MHObject+Internal.h"


@implementation MHPeriodicalSeries

@declare_class_property (mhidPrefix, @"mhpds")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloLiterature;
}

+ (void)load
{
    [self registerMHObject];
}

@end
