//
//  MHComicBook.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
