//
//  MHNovella.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHNovella.h"
#import "MHObject+Internal.h"


@implementation MHNovella

@declare_class_property (mhidPrefix, @"mhnov")

+ (void)load
{
    [self registerMHObject];
}

@end
