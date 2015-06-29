//
//  MHAudience.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAudience.h"
#import "MHObject+Internal.h"


@implementation MHAudience

@declare_class_property (mhidPrefix, @"mhaud")

+ (void)load
{
    [self registerMHObject];
}

@end
