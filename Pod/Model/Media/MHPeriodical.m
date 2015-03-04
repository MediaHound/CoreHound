//
//  MHPeriodical.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHPeriodical.h"
#import "MHObject+Internal.h"


@implementation MHPeriodical

@declare_class_property (mhidPrefix, @"mhpdc")

+ (void)load
{
    [self registerMHObject];
}

@end
