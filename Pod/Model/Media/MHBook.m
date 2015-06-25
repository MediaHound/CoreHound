//
//  MHBook.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
