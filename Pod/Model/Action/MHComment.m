//
//  MHComment.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
