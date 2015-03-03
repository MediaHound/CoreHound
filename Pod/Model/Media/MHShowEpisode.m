//
//  MHShowEpisode.m
//  MediaHound
//
//  Created by Andrew O'Toole on 9/06/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
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
