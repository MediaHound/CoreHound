//
//  MHSubscription.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHSubscription.h"
#import "MHObject+Internal.h"


@implementation MHSubscription

+ (void)load
{
    [self registerMHObject];
}

@declare_class_property (mhidPrefix, @"mhsub")
@declare_class_property (rootEndpoint, @"graph/subscription")

- (NSString*)displayPrice
{
    // TODO: Handle other kinds of currency
    static NSNumberFormatter* s_numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_numberFormatter = [[NSNumberFormatter alloc] init];
        s_numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    });
    return [NSString stringWithFormat:@"%@", [s_numberFormatter stringFromNumber:self.metadata.price]];
}

@end
