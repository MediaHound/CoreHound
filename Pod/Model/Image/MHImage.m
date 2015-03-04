//
//  MHImage.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHImage.h"
#import "MHObject+Internal.h"


@implementation MHImage

@declare_class_property (mhidPrefix, @"mhimg")
@declare_class_property (rootEndpoint, @"graph/image")

+ (void)load
{
    [self registerMHObject];
}

@end
