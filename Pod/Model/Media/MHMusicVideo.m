//
//  MHMusicVideo.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/2/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
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
