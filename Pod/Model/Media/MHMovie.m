//
//  MHMovie.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMovie.h"
#import "MHObject+Internal.h"


@implementation MHMovie

@declare_class_property (mhidPrefix, @"mhmov")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloVideo;
}

+ (void)load
{
    [self registerMHObject];
}

@end
