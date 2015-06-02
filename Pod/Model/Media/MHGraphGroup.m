//
//  MHGraphGroup.m
//  CoreHound
//
//  Created by Dustin Bachrach on 6/2/15.
//
//

#import "MHGraphGroup.h"
#import "MHObject+Internal.h"


@implementation MHGraphGroup

@declare_class_property (mhidPrefix, @"mhggp")

+ (void)load
{
    [self registerMHObject];
}

@end
