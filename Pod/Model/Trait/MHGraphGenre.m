//
//  MHGraphGenre.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHGraphGenre.h"
#import "MHObject+Internal.h"


@implementation MHGraphGenre

@declare_class_property (mhidPrefix, @"mhgrg")

+ (void)load
{
    [self registerMHObject];
}

@end
