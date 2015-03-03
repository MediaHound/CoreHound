//
//  MHShowSeason.m
//  MediaHound
//
//  Created by Andrew O'Toole on 9/06/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHShowSeason.h"
#import "MHObject+Internal.h"


@implementation MHShowSeason

@declare_class_property (mhidPrefix, @"mhssn")

+ (void)load
{
    [self registerMHObject];
}

@end
