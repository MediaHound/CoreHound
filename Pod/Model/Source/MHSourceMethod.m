//
//  MHSourceMethod.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHSourceMethod.h"
#import "MHSourceMedium+Internal.h"
#import "MHSourceFormat+Internal.h"
#import "MHSourceMedium.h"
#import "MHSimpleProxy.h"

NSString* const MHSourceMethodTypePurchase = @"purchase";
NSString* const MHSourceMethodTypeRental = @"rental";
NSString* const MHSourceMethodTypeSubscription = @"subscription";
NSString* const MHSourceMethodTypeAdSupported = @"adSupported";
NSString* const MHSourceMethodTypeBroker = @"broker";


@interface MHSourceMethod ()

@property (weak, nonatomic, readwrite) MHSourceMedium<Ignore>* medium;

@property (strong, nonatomic) NSArray<MHSourceFormat>* formats;

@end


@implementation MHSourceMethod

- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError**)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        for (MHSourceFormat* format in self.formats) {
            format.method = self;
        }
    }
    return self;
}

- (MHSourceFormat*)formatForType:(NSString*)type
{
    id object = nil;
    for (MHSourceFormat* format in self.formats) {
        if ([format.type isEqualToString:type]) {
            object = format;
            break;
        }
    }
    
    if (object) {
        return (MHSourceFormat*)[[MHSimpleProxy alloc] initWithObject:object context:self.medium.context];
    }
    else {
        return nil;
    }
}

- (MHSourceFormat*)defaultFormat
{
    return (MHSourceFormat*)[[MHSimpleProxy alloc] initWithObject:self.formats.firstObject context:self.medium.context];
}

- (NSArray*)allFormats
{
    NSMutableArray* proxiedFormats = [NSMutableArray array];
    
    for (MHSourceFormat* format in self.formats) {
        MHSimpleProxy* proxiedFormat = [[MHSimpleProxy alloc] initWithObject:format
                                                                     context:self.medium.context];
        [proxiedFormats addObject:proxiedFormat];
    }
    return proxiedFormats;
}

- (NSString*)displayName
{
    NSString* mediumType = self.medium.type;
    NSString* methodType = self.type;
    
    if ([mediumType isEqualToString:MHSourceMediumTypeStream]) {
        if ([methodType isEqualToString:MHSourceMethodTypeSubscription]) {
            return NSLocalizedString(@"Streaming Subscription", nil);
        }
        else if ([methodType isEqualToString:MHSourceMethodTypePurchase]) {
            return NSLocalizedString(@"Streaming Purchase", nil);
        }
        else if ([methodType isEqualToString:MHSourceMethodTypeRental]) {
            return NSLocalizedString(@"Streaming Rental", nil);
        }
        else if ([methodType isEqualToString:MHSourceMethodTypeAdSupported]) {
            return NSLocalizedString(@"Ad-Supported Streaming", nil);
        }
    }
    if ([mediumType isEqualToString:MHSourceMediumTypeDownload]) {
        if ([methodType isEqualToString:MHSourceMethodTypePurchase]) {
            return NSLocalizedString(@"Digital Purchase", nil);
        }
        else if ([methodType isEqualToString:MHSourceMethodTypeRental]) {
            return NSLocalizedString(@"Digital Rental", nil);
        }
    }
    if ([mediumType isEqualToString:MHSourceMediumTypeDeliver]) {
        if ([methodType isEqualToString:MHSourceMethodTypeSubscription]) {
            return NSLocalizedString(@"Delivery Subscription", nil);
        }
    }
    return nil;
}

@end
