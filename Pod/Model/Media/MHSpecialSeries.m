//
//  MHSpecialSeries.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSpecialSeries.h"
#import "MHObject+Internal.h"


@implementation MHSpecialSeries

@declare_class_property (mhidPrefix, @"mhsps")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloVideo;
}

+ (void)load
{
    [self registerMHObject];
}

@end
