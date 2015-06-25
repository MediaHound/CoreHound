//
//  MHShowSeries.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHShowSeries.h"
#import "MHObject+Internal.h"


@implementation MHShowSeries

@declare_class_property (mhidPrefix, @"mhsss")

+ (void)load
{
    [self registerMHObject];
}

@end
