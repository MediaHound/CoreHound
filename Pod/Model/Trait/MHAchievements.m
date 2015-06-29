//
//  MHAchievements.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAchievements.h"
#import "MHObject+Internal.h"


@implementation MHAchievements

@declare_class_property (mhidPrefix, @"mhach")

+ (void)load
{
    [self registerMHObject];
}

@end
