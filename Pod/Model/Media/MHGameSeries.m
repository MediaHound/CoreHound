//
//  MHGameSeries.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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
