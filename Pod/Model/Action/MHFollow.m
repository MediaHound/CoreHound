//
//  MHFollow.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHFollow.h"
#import "MHObject+Internal.h"


@implementation MHFollow

@declare_class_property (mhidPrefix, @"mhflw")

+ (void)load
{
    [self registerMHObject];
}

@end
