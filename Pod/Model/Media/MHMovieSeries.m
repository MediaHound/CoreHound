//
//  MHMovieSeries.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMovieSeries.h"
#import "MHObject+Internal.h"


@implementation MHMovieSeries

@declare_class_property (mhidPrefix, @"mhmvs")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloVideo;
}

+ (void)load
{
    [self registerMHObject];
}

@end
