//
//  MHGraphicNovel.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHGraphicNovel.h"
#import "MHObject+Internal.h"


@implementation MHGraphicNovel

@declare_class_property (mhidPrefix, @"mhgnl")

+ (void)load
{
    [self registerMHObject];
}

@end
