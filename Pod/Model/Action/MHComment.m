//
//  MHComment.m
//  mediaHound
//
//  Created by Dustin Bachrach on 6/10/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHComment.h"
#import "MHObject+Internal.h"


@implementation MHComment

@declare_class_property (mhidPrefix, @"mhcmt")

+ (void)load
{
    [self registerMHObject];
}

@end
