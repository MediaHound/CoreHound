//
//  MHComicBookSeries.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHComicBookSeries.h"
#import "MHObject+Internal.h"


@implementation MHComicBookSeries

@declare_class_property (mhidPrefix, @"mhcbs")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloLiterature;
}

+ (void)load
{
    [self registerMHObject];
}

@end
