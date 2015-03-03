//
//  MHBookSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHBookSeries.h"
#import "MHObject+Internal.h"


@implementation MHBookSeries

@declare_class_property (mhidPrefix, @"mhbks")

+ (void)load
{
    [self registerMHObject];
}

@end
