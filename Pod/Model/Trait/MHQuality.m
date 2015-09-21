//
//  MHQuality.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHQuality.h"
#import "MHObject+Internal.h"


@implementation MHQuality

@declare_class_property (mhidPrefix, @"mhqlt")

+ (void)load
{
    [self registerMHObject];
}

@end
