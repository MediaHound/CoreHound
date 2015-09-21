//
//  MHMovie.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMovie.h"
#import "MHObject+Internal.h"


@implementation MHMovie

@declare_class_property (mhidPrefix, @"mhmov")

+ (void)load
{
    [self registerMHObject];
}

@end
