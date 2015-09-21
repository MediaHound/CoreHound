//
//  MHTheme.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHTheme.h"
#import "MHObject+Internal.h"


@implementation MHTheme

@declare_class_property (mhidPrefix, @"mhthm")

+ (void)load
{
    [self registerMHObject];
}

@end
