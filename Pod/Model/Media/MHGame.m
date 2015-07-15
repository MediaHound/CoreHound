//
//  MHGame.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHGame.h"
#import "MHObject+Internal.h"


@implementation MHGame

@declare_class_property (mhidPrefix, @"mhgam")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloGaming;
}

+ (void)load
{
    [self registerMHObject];
}

@end
