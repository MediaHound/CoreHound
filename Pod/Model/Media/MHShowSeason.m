//
//  MHShowSeason.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHShowSeason.h"
#import "MHObject+Internal.h"


@implementation MHShowSeason

@declare_class_property (mhidPrefix, @"mhssn")

+ (void)load
{
    [self registerMHObject];
}

@end
