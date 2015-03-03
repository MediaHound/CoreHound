//
//  MHCreate.m
//  mediaHound
//
//  Created by Dustin Bachrach on 6/10/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHCreate.h"
#import "MHObject+Internal.h"


@implementation MHCreate

@declare_class_property (mhidPrefix, @"mhcrt")

+ (void)load
{
    [self registerMHObject];
}

@end
