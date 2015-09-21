//
//  MHGenre.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHGenre.h"
#import "MHObject+Internal.h"


@implementation MHGenre

@declare_class_property (mhidPrefix, @"mhgnr")

+ (void)load
{
    [self registerMHObject];
}

@end
