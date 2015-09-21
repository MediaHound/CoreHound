//
//  MHMaterialSource.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMaterialSource.h"
#import "MHObject+Internal.h"


@implementation MHMaterialSource

@declare_class_property (mhidPrefix, @"mhmts")

+ (void)load
{
    [self registerMHObject];
}

@end
