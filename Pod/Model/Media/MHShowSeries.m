//
//  MHShowSeries.m
//  MediaHound
//
//  Created by Andrew O'Toole on 9/06/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHShowSeries.h"
#import "MHObject+Internal.h"


@implementation MHShowSeries

@declare_class_property (mhidPrefix, @"mhsss")

+ (void)load
{
    [self registerMHObject];
}

@end
