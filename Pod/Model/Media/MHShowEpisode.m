//
//  MHShowEpisode.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHShowEpisode.h"
#import "MHObject+Internal.h"


@implementation MHShowEpisode

@declare_class_property (mhidPrefix, @"mhsep")

+ (void)load
{
    [self registerMHObject];
}

@end
