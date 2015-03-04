//
//  MHSpecial.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHSpecial.h"
#import "MHObject+Internal.h"


@implementation MHSpecial

@declare_class_property (mhidPrefix, @"mhspc")

+ (void)load
{
    [self registerMHObject];
}

@end
