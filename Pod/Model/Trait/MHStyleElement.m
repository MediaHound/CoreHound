//
//  MHStyleElement.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHStyleElement.h"
#import "MHObject+Internal.h"


@implementation MHStyleElement

@declare_class_property (mhidPrefix, @"mhsty")

+ (void)load
{
    [self registerMHObject];
}

@end
