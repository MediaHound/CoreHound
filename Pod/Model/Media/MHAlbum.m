//
//  MHAlbum.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAlbum.h"
#import "MHObject+Internal.h"


@implementation MHAlbum

@declare_class_property (mhidPrefix, @"mhalb")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloAudio;
}

+ (void)load
{
    [self registerMHObject];
}

@end
