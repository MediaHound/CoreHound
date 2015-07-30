//
//  MHPublish.m
//  CoreHound
//
//  Created by Dustin Bachrach on 7/30/15.
//
//

#import "MHPublish.h"
#import "MHObject+Internal.h"


@implementation MHPublish

@declare_class_property (mhidPrefix, @"mhpbl")

+ (void)load
{
    [self registerMHObject];
}

@end
