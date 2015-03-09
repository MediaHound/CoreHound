//
//  MHNovella.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHNovella.h"
#import "MHObject+Internal.h"


@implementation MHNovella

@declare_class_property (mhidPrefix, @"mhnov")

+ (void)load
{
    [self registerMHObject];
}

@end
