//
//  MHGraphicNovel.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHGraphicNovel.h"
#import "MHObject+Internal.h"


@implementation MHGraphicNovel

@declare_class_property (mhidPrefix, @"mhgnl")

+ (void)load
{
    [self registerMHObject];
}

@end
