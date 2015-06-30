//
//  MHRelationalPair.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHRelationalPair.h"


@implementation MHRelationalPair

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(object))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(context))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

@end
