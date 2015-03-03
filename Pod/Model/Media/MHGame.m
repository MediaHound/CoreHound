//
//  Game.m
//  MediaHound
//
//  Created by Andrew O'Toole on 9/06/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHGame.h"
#import "MHObject+Internal.h"


@implementation MHGame

@declare_class_property (mhidPrefix, @"mhgam")

+ (void)load
{
    [self registerMHObject];
}

@end
