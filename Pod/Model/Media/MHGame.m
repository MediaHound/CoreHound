//
//  MHGame.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHGame.h"
#import "MHObject+Internal.h"


@implementation MHGame

@declare_class_property (mhidPrefix, @"mhgam")

+ (void)load
{
    [self registerMHObject];
}

@end
