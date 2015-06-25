//
//  MHAlbumSeries.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
