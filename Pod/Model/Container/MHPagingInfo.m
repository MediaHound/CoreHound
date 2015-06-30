//
//  MHPagingInfo.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHPagingInfo.h"


@implementation MHPagingInfo

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(next))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

@end
