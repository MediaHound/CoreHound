//
//  MHMusicVideo.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
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
