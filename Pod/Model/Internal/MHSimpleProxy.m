//
//  MHSimpleProxy.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSimpleProxy.h"


@interface MHSimpleProxy ()

@property (strong, nonatomic, readwrite) MHContext* context;
@property (strong, nonatomic, readwrite) id proxiedObject;

@end


@implementation MHSimpleProxy

- (instancetype)initWithObject:(id)object context:(MHContext*)context
{
    _proxiedObject = object;
    _context = context;
    
    return self;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    return [self.proxiedObject methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    [invocation invokeWithTarget:self.proxiedObject];
}

- (Class)class
{
    return [self.proxiedObject class];
}

@end
