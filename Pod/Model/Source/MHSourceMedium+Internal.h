//
//  MHSourceMedium+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSourceMedium.h"

@class MHSource;
@class MHObject;
@class MHContext;


@interface MHSourceMedium (Internal)

@property (weak, nonatomic, readwrite) MHSource* source;
@property (weak, nonatomic, readwrite) MHObject* content;

@property (weak, nonatomic) MHContext* context;

@end
