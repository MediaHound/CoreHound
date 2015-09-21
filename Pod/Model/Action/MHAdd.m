//
//  MHAdd.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAdd.h"
#import "MHObject+Internal.h"


@implementation MHAdd

@declare_class_property (mhidPrefix, @"mhadd")

+ (void)load
{
    [self registerMHObject];
}

@end
