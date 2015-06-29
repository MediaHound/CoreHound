//
//  MHStoryElement.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHStoryElement.h"
#import "MHObject+Internal.h"


@implementation MHStoryElement

@declare_class_property (mhidPrefix, @"mhgstr")

+ (void)load
{
    [self registerMHObject];
}

@end
