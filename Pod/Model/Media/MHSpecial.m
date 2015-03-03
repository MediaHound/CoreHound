//
//  MHSpecial.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
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
