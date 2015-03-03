//
//  MHFollow.m
//  mediaHound
//
//  Created by Dustin Bachrach on 6/10/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHFollow.h"
#import "MHObject+Internal.h"


@implementation MHFollow

@declare_class_property (mhidPrefix, @"mhflw")

+ (void)load
{
    [self registerMHObject];
}

@end
