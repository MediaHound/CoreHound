//
//  MHPeriodical.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
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
