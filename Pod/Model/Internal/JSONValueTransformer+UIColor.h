//
//  JSONValueTransformer+UIColor.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONValueTransformer.h>


@interface JSONValueTransformer (UIColor)

- (UIColor*)UIColorFromNSString:(NSString*)string;

@end
