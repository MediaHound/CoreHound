//
//  MHMood.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMood.h"
#import "MHObject+Internal.h"


@implementation MHMood

@declare_class_property (mhidPrefix, @"mhmod")

+ (void)load
{
    [self registerMHObject];
}

@end
