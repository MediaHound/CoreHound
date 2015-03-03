//
//  MHSpecialSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
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
