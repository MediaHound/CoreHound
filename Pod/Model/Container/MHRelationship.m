//
//  MHRelationship.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHRelationship.h"


@implementation MHRelationship

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(role))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(object))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}
@end
