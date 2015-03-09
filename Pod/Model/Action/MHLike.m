//
//  MHLike.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHLike.h"
#import "MHObject+Internal.h"


@implementation MHLike

@declare_class_property (mhidPrefix, @"mhlke")

+ (void)load
{
    [self registerMHObject];
}

@end
