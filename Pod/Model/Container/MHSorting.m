//
//  MHSorting.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHSorting.h"


@implementation MHSorting

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(importance))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(position))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

@end
