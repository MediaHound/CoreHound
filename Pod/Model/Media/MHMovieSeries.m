//
//  MHMovieSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHMovieSeries.h"
#import "MHObject+Internal.h"


@implementation MHMovieSeries

@declare_class_property (mhidPrefix, @"mhmvs")

+ (void)load
{
    [self registerMHObject];
}

@end
