//
//  MHBookSeries.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHBookSeries.h"
#import "MHObject+Internal.h"


@implementation MHBookSeries

@declare_class_property (mhidPrefix, @"mhbks")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloLiterature;
}

+ (void)load
{
    [self registerMHObject];
}

@end
