//
//  MHAnthology.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAnthology.h"
#import "MHObject+Internal.h"


@implementation MHAnthology

@declare_class_property (mhidPrefix, @"mhath")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloLiterature;
}

+ (void)load
{
    [self registerMHObject];
}

@end
