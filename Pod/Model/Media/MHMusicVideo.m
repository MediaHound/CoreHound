//
//  MHMusicVideo.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMusicVideo.h"
#import "MHObject+Internal.h"


@implementation MHMusicVideo

@declare_class_property (mhidPrefix, @"mhmsv")

+ (void)load
{
    [self registerMHObject];
}

@end
