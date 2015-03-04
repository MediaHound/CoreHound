//
//  MHSimpleProxy.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHRelationalPair.h"


@interface MHSimpleProxy : NSProxy

- (instancetype)initWithObject:(id)object context:(MHContext*)context;

@property (strong, nonatomic, readonly) MHContext* context;
@property (strong, nonatomic, readonly) id proxiedObject;

@end
