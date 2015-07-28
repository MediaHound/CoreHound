//
//  MHSourceFormat.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSourceFormat.h"

NSString* const MHSourceFormatLaunchInfoViewKey = @"view";
NSString* const MHSourceFormatLaunchInfoConsumeKey = @"consume";
NSString* const MHSourceFormatLaunchInfoPreviewKey = @"preview";
NSString* const MHSourceFormatLaunchInfoSourceIdKey = @"sourceId";

NSString* const MHSourceFormatLaunchInfoViewTypeIOSKey = @"ios";
NSString* const MHSourceFormatLaunchInfoViewTypeHTTPKey = @"http";

NSString* const MHSourceFormatTypeUnknownKey = @"unknown";


@interface MHSourceFormat ()

@property (weak, nonatomic, readwrite) MHSourceMethod* method;

@end


@implementation MHSourceFormat

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(method))]) {
        return YES;
    }
    return [super propertyIsIgnored:propertyName];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(price))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(currency))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(timePeriod))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(contentCount))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (NSString*)displayPrice
{
    // TODO: Handle other kinds of currency
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:self.price]];
}

@end
