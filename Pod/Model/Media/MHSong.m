//
//  MHSong.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHSong.h"
#import "MHObject+Internal.h"


@implementation MHSong

@declare_class_property (mhidPrefix, @"mhsng")

+ (void)load
{
    [self registerMHObject];
}

@end
