//
//  MHShowSeason.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
