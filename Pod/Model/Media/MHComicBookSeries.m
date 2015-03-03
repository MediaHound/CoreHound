//
//  MHComicBookSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHComicBookSeries.h"
#import "MHObject+Internal.h"


@implementation MHComicBookSeries

@declare_class_property (mhidPrefix, @"mhcbs")

+ (void)load
{
    [self registerMHObject];
}

@end
