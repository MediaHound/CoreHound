//
//  MHAnthology.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHAnthology.h"
#import "MHObject+Internal.h"


@implementation MHAnthology

@declare_class_property (mhidPrefix, @"mhath")

+ (void)load
{
    [self registerMHObject];
}

@end
