//
//  MHPublish.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHPublish.h"
#import "MHObject+Internal.h"


@implementation MHPublish

@declare_class_property (mhidPrefix, @"mhpbl")

+ (void)load
{
    [self registerMHObject];
}

@end
