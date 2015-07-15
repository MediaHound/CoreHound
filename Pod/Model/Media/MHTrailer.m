//
//  MHTrailer.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHTrailer.h"
#import "MHObject+Internal.h"


@implementation MHTrailer

@declare_class_property (mhidPrefix, @"mhtrl")

+ (MHEntertainmentSilo)entertainmentSilo
{
    return MHEntertainmentSiloVideo;
}

+ (void)load
{
    [self registerMHObject];
}

@end
