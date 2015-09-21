//
//  MHTrack.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHTrack.h"
#import "MHObject+Internal.h"


@implementation MHTrack

@declare_class_property (mhidPrefix, @"mhsng")

+ (void)load
{
    [self registerMHObject];
}

@end
