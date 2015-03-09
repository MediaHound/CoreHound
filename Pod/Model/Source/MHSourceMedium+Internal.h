//
//  MHSourceMedium+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHSourceMedium.h"

@class MHSource;
@class MHObject;
@class MHContext;


@interface MHSourceMedium (Internal)

@property (weak, nonatomic, readwrite) MHSource<Ignore>* source;
@property (weak, nonatomic, readwrite) MHObject<Ignore>* content;

@property (weak, nonatomic) MHContext<Ignore>* context;

@end
