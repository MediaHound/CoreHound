//
//  MHAction.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHAction.h"
#import "MHObject+Internal.h"


@implementation MHAction

@dynamic metadata;

@declare_class_property (rootEndpoint, @"graph/action")

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(primaryMention))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(primaryOwner))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

@end
