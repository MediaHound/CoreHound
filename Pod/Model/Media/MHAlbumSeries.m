//
//  MHAlbumSeries.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHAlbumSeries.h"
#import "MHObject+Internal.h"


@implementation MHAlbumSeries

@declare_class_property (mhidPrefix, @"mhals")

+ (void)load
{
    [self registerMHObject];
}

@end
