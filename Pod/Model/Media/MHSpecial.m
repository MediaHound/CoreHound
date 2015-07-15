//
//  MHSpecial.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSpecial.h"
#import "MHObject+Internal.h"


@implementation MHSpecial

@declare_class_property (mhidPrefix, @"mhspc")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloVideo;
}

+ (void)load
{
    [self registerMHObject];
}

@end
