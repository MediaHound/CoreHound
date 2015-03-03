//
//  MHTrailer.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHTrailer.h"
#import "MHObject+Internal.h"


@implementation MHTrailer

@declare_class_property (mhidPrefix, @"mhtrl")

+ (void)load
{
    [self registerMHObject];
}

@end
