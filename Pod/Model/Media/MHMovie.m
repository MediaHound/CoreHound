//
//  Movie.m
//  MediaHound
//
//  Created by Tai Bo on 8/4/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHMovie.h"
#import "MHObject+Internal.h"


@implementation MHMovie

@declare_class_property (mhidPrefix, @"mhmov")

+ (void)load
{
    [self registerMHObject];
}

@end
