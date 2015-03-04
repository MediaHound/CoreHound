//
//  MHAnthology.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHAnthology.h"
#import "MHObject+Internal.h"


@implementation MHAnthology

@declare_class_property (mhidPrefix, @"mhath")

+ (void)load
{
    [self registerMHObject];
}

@end
