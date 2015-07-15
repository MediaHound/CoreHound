//
//  MHGraphicNovel.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHGraphicNovel.h"
#import "MHObject+Internal.h"


@implementation MHGraphicNovel

@declare_class_property (mhidPrefix, @"mhgnl")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloLiterature;
}

+ (void)load
{
    [self registerMHObject];
}

@end
