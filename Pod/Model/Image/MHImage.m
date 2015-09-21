//
//  MHImage.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHImage.h"
#import "MHObject+Internal.h"


@implementation MHImage

@dynamic metadata;

@declare_class_property (mhidPrefix, @"mhimg")
@declare_class_property (rootEndpoint, @"graph/image")

+ (void)load
{
    [self registerMHObject];
}

@end
