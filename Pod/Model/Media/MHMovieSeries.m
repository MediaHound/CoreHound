//
//  MHMovieSeries.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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
