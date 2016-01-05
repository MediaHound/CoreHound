//
//  MHSuitability.m
//  CoreHound
//
//  Created by Dustin Bachrach on 1/5/16.
//
//

#import "MHSuitability.h"
#import "MHObject+Internal.h"


@implementation MHSuitability

@declare_class_property (mhidPrefix, @"mhstb")

+ (void)load
{
    [self registerMHObject];
}

@end
