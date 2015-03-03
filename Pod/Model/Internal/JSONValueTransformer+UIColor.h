//
//  JSONValueTransformer+UIColor.h
//  mediaHound
//
//  Created by Dustin Bachrach on 9/4/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "JSONValueTransformer.h"


@interface JSONValueTransformer (UIColor)

- (UIColor*)UIColorFromNSString:(NSString*)string;

@end
