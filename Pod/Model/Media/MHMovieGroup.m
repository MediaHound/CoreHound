//
//  MHMovieGroup.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHMovieGroup.h"
#import "MHObject+Internal.h"


@implementation MHMovieGroup

@declare_class_property (mhidPrefix, @"mhmvg")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloVideo;
}


+ (void)load
{
    [self registerMHObject];
}

@end
