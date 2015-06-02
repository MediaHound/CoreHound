//
//  MHMovieGroup.m
//  CoreHound
//
//  Created by Dustin Bachrach on 6/2/15.
//
//

#import "MHMovieGroup.h"
#import "MHObject+Internal.h"


@implementation MHMovieGroup

@declare_class_property (mhidPrefix, @"mhmvg")

+ (void)load
{
    [self registerMHObject];
}

@end
