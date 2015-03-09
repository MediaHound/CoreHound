//
//  MHBookSeries.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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
