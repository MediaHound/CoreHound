//
//  Book.m
//  MediaHound
//
//  Created by Andrew O'Toole on 9/06/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHBook.h"
#import "MHObject+Internal.h"


@implementation MHBook

@declare_class_property (mhidPrefix, @"mhbok")

+ (void)load
{
    [self registerMHObject];
}

@end
