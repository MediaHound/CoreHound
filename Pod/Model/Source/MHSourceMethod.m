//
//  MHSourceMethod.m
//  CoreHound
//
//  Created by Dustin Bachrach on 1/21/15.
//
//

#import "MHSourceMethod.h"
#import "MHSourceMedium+Internal.h"
#import "MHSourceFormat+Internal.h"
#import "MHSourceMedium.h"
#import "MHSimpleProxy.h"

#import <Underscore.m/Underscore.h>
@compatibility_alias _ Underscore;

NSString* const MHSourceMethodTypePurchase = @"purchase";
NSString* const MHSourceMethodTypeRental = @"rental";
NSString* const MHSourceMethodTypeSubscription = @"subscription";
NSString* const MHSourceMethodTypeAdSupported = @"adSupported";


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
    id object = _.find(self.formats, ^BOOL(MHSourceFormat* f) {
        return [f.type isEqualToString:type];
    });
    return (MHSourceFormat*)[[MHSimpleProxy alloc] initWithObject:object context:self.medium.context];
}

- (MHSourceFormat*)defaultFormat
{
    return (MHSourceFormat*)[[MHSimpleProxy alloc] initWithObject:self.formats.firstObject context:self.medium.context];
}

- (NSArray*)allFormats
{
    return _.arrayMap(self.formats, ^(MHSourceFormat* f) {
        return [[MHSimpleProxy alloc] initWithObject:f context:self.medium.context];
    });
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
