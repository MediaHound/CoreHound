//
//  MHTrailer.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHTrailer.h"
#import "MHObject+Internal.h"


@implementation MHTrailer

@declare_class_property (mhidPrefix, @"mhtrl")

+ (void)load
{
    [self registerMHObject];
}

@end
