//
//  MHMovie.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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
