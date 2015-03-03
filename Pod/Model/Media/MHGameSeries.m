//
//  MHGameSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHGameSeries.h"
#import "MHObject+Internal.h"


@implementation MHGameSeries

@declare_class_property (mhidPrefix, @"mhgms")

+ (void)load
{
    [self registerMHObject];
}

@end
