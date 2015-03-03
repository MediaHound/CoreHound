//
//  MHAdd.m
//  mediaHound
//
//  Created by Dustin Bachrach on 6/10/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHAdd.h"
#import "MHObject+Internal.h"


@implementation MHAdd

@declare_class_property (mhidPrefix, @"mhadd")

+ (void)load
{
    [self registerMHObject];
}

@end
