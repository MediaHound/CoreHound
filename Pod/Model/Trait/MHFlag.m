//
//  MHFlag.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHFlag.h"
#import "MHObject+Internal.h"


@implementation MHFlag

@declare_class_property (mhidPrefix, @"mhflg")

+ (void)load
{
    [self registerMHObject];
}

@end
