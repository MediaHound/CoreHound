//
//  Song.m
//  MediaHound
//
//  Created by Tai Bo on 8/29/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
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
