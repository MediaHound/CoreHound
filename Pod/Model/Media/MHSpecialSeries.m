//
//  MHSpecialSeries.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHSpecialSeries.h"
#import "MHObject+Internal.h"


@implementation MHSpecialSeries

@declare_class_property (mhidPrefix, @"mhsps")

+ (void)load
{
    [self registerMHObject];
}

@end
