//
//  MHAchievement.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAchievement.h"
#import "MHObject+Internal.h"


@implementation MHAchievement

@declare_class_property (mhidPrefix, @"mhach")

+ (void)load
{
    [self registerMHObject];
}

@end
