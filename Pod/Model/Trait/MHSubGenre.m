//
//  MHSubGenre.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSubGenre.h"
#import "MHObject+Internal.h"


@implementation MHSubGenre

@declare_class_property (mhidPrefix, @"mhsgn")

+ (void)load
{
    [self registerMHObject];
}

@end
