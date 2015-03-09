//
//  MHBook.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHBook.h"
#import "MHObject+Internal.h"


@implementation MHBook

@declare_class_property (mhidPrefix, @"mhbok")

+ (void)load
{
    [self registerMHObject];
}

@end
