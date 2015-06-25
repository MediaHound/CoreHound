//
//  MHCreate.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
