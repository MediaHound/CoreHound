//
//  MHAlbum.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHAlbum.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"


@implementation MHAlbum

@declare_class_property (mhidPrefix, @"mhalb")

+ (void)load
{
    [self registerMHObject];
}

@end
