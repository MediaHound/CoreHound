//
//  MHImageData.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHImageData.h"


@implementation MHImageData

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:MHImageData.class]) {
        return NO;
    }
    
    return [self isEqualToMHImageData:(MHImageData*)object];
}

- (BOOL)isEqualToMHImageData:(MHImageData*)imageData
{
    return ((!self.url && !imageData.url) || ([self.url isEqual:imageData.url]))
    && ((!self.width && !imageData.width) || ([self.width isEqual:imageData.width]))
    && ((!self.height && !imageData.height) || ([self.height isEqual:imageData.height]));
}

- (NSUInteger)hash
{
    return self.url.hash
    ^ self.width.hash
    ^ self.height.hash;
}

@end
