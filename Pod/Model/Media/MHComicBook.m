//
//  MHComicBook.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/3/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHComicBook.h"
#import "MHObject+Internal.h"


@implementation MHComicBook

@declare_class_property (mhidPrefix, @"mhcbk")

+ (void)load
{
    [self registerMHObject];
}

@end
