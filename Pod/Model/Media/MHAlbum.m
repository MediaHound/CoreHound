//
//  Album.m
//  MediaHound
//
//  Created by Andrew O'Toole on 9/06/13.
//  Copyright (c) 2013 Media Hound. All rights reserved.
//

#import "MHAlbum.h"
#import "MHObject+Internal.h"
#import "MHFetcher.h"


@implementation MHAlbum

@declare_class_property (mhidPrefix, @"mhalb")

+ (void)load
{
    [self registerMHObject];
}

@end
