//
//  JSONValueTransformer+UIColor.m
//  mediaHound
//
//  Created by Dustin Bachrach on 9/4/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "JSONValueTransformer+UIColor.h"


@implementation JSONValueTransformer (UIColor)

- (UIColor*)UIColorFromNSString:(NSString*)string
{
    NSString* noHashString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner* scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) {
        return nil;
    }
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

@end
