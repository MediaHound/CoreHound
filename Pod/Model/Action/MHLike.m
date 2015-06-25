//
//  MHLike.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
