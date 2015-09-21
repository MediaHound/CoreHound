//
//  MHEra.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHEra.h"
#import "MHObject+Internal.h"


@implementation MHEra

@declare_class_property (mhidPrefix, @"mhera")

+ (void)load
{
    [self registerMHObject];
}

@end
