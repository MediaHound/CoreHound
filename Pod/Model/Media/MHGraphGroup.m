//
//  MHGraphGroup.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHGraphGroup.h"
#import "MHObject+Internal.h"


@implementation MHGraphGroup

@declare_class_property (mhidPrefix, @"mhggp")

+ (void)load
{
    [self registerMHObject];
}

@end
