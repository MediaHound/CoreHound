//
//  MHSimpleProxy.h
//  CoreHound
//
//  Created by Dustin Bachrach on 1/22/15.
//
//

#import <Foundation/Foundation.h>

#import "MHRelationalPair.h"


@interface MHSimpleProxy : NSProxy

- (instancetype)initWithObject:(id)object context:(MHContext*)context;

@property (strong, nonatomic, readonly) MHContext* context;
@property (strong, nonatomic, readonly) id proxiedObject;

@end
