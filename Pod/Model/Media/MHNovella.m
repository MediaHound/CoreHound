//
//  MHNovella.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHNovella.h"
#import "MHObject+Internal.h"


@implementation MHNovella

@declare_class_property (mhidPrefix, @"mhnov")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloLiterature;
}

+ (void)load
{
    [self registerMHObject];
}

@end
