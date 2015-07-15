//
//  MHMetadata.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHMetadata.h"


@implementation MHMetadata

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"objectDescription": @"description",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(name))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(objectDescription))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(createdDate))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    
    return [self isEqualToMHMetadata:(MHMetadata*)object];
}

- (BOOL)isEqualToMHMetadata:(MHMetadata*)metadata
{
    return ((!self.mhid && !metadata.mhid) || ([self.mhid isEqual:metadata.mhid]))
    && ((!self.name && !metadata.name) || ([self.name isEqual:metadata.name]))
    && ((!self.objectDescription && !metadata.objectDescription) || ([self.objectDescription isEqual:metadata.objectDescription]))
    && ((!self.createdDate && !metadata.createdDate) || ([self.createdDate isEqual:metadata.createdDate]));
}

- (NSUInteger)hash
{
    return self.mhid.hash
    ^ self.name.hash
    ^ self.objectDescription.hash
    ^ self.createdDate.hash;
}

@end


@implementation MHMediaMetadata

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(releaseDate))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (BOOL)isEqualToMHMetadata:(MHMediaMetadata*)metadata
{
    return [super isEqualToMHMetadata:metadata]
    && ((!self.releaseDate && !metadata.releaseDate) || ([self.releaseDate isEqual:metadata.releaseDate]));
}

- (NSUInteger)hash
{
    return super.hash
    ^ self.releaseDate.hash;
}

@end


@implementation MHUserMetadata

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(email))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (BOOL)isEqualToMHMetadata:(MHUserMetadata*)metadata
{
    return [super isEqualToMHMetadata:metadata]
    && ((!self.username && !metadata.username) || ([self.username isEqual:metadata.username]))
    && ((!self.email && !metadata.email) || ([self.email isEqual:metadata.email]));
}

- (NSUInteger)hash
{
    return super.hash
    ^ self.username.hash
    ^ self.email.hash;
}

@end


@implementation MHImageMetadata

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(original))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(thumbnail))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(small))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(medium))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(large))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(isDefault))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(averageColor))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (BOOL)isEqualToMHMetadata:(MHImageMetadata*)metadata
{
    return [super isEqualToMHMetadata:metadata]
    && ((!self.isDefault && !metadata.isDefault) || ([self.isDefault isEqual:metadata.isDefault]))
    && ((!self.averageColor && !metadata.averageColor) || ([self.averageColor isEqual:metadata.averageColor]));
}

- (NSUInteger)hash
{
    return super.hash
    ^ self.isDefault.hash
    ^ self.averageColor.hash;
}

@end


@implementation MHActionMetadata

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(message))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (BOOL)isEqualToMHMetadata:(MHActionMetadata*)metadata
{
    return [super isEqualToMHMetadata:metadata]
    && ((!self.message && !metadata.message) || ([self.message isEqual:metadata.message]));
}

- (NSUInteger)hash
{
    return super.hash
    ^ self.message.hash;
}

@end


@implementation MHCollectionMetadata

// TODO: Remove this once search indexes the mixlist property
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(mixlist))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

- (void)setMixlistWithNSString:(NSString*)mixlistValue
{
    NSDictionary* mixlistKindMapping = @{
                                         @"None": @(MHCollectionMixlistTypeNone),
                                         @"Partial": @(MHCollectionMixlistTypePartial),
                                         @"Full": @(MHCollectionMixlistTypeFull)
                                         };
    NSNumber* type = mixlistKindMapping[mixlistValue];
    if (type) {
        if (type.integerValue != self.mixlist) {
            self.mixlist = type.integerValue;
        }
    }
}

- (BOOL)isEqualToMHMetadata:(MHCollectionMetadata*)metadata
{
    return [super isEqualToMHMetadata:metadata]
    && (self.mixlist == metadata.mixlist);
}

- (NSUInteger)hash
{
    return super.hash
    ^ @(self.mixlist).hash;
}

@end


@implementation MHSubscriptionMetadata

- (BOOL)isEqualToMHMetadata:(MHSubscriptionMetadata*)metadata
{
    return [super isEqualToMHMetadata:metadata]
    && ((!self.timePeriod && !metadata.timePeriod) || ([self.timePeriod isEqual:metadata.timePeriod]))
    && ((!self.price && !metadata.price) || ([self.price isEqual:metadata.price]))
    && ((!self.currency && !metadata.currency) || ([self.currency isEqual:metadata.currency]))
    && ((!self.mediums && !metadata.mediums) || ([self.mediums isEqual:metadata.mediums]));
}

- (NSUInteger)hash
{
    return super.hash
    ^ self.timePeriod.hash
    ^ self.price.hash
    ^ self.currency.hash
    ^ self.mediums.hash;
}

@end

@implementation MHSourceMetadata

- (BOOL)isEqualToMHMetadata:(MHSourceMetadata*)metadata
{
    return [super isEqualToMHMetadata:metadata]
    && ((!self.connectable && !metadata.connectable) || ([self.connectable isEqual:metadata.connectable]));
}

- (NSUInteger)hash
{
    return super.hash
    ^ self.connectable.hash;
}

@end
