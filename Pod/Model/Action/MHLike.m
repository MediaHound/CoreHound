//
//  MHLike.m
//  mediaHound
//
//  Created by Dustin Bachrach on 6/10/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHLike.h"
#import "MHObject+Internal.h"


@implementation MHLike

@declare_class_property (mhidPrefix, @"mhlke")

+ (void)load
{
    [self registerMHObject];
}

@end
