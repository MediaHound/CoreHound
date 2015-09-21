//
//  MHContext.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import "MHContext.h"
#import "MHSimpleProxy.h"
#import "MHSourceMedium.h"
#import "MHSourceMedium+Internal.h"


@interface MHContext ()

@property (strong, nonatomic) NSArray* mediums;

@end


@implementation MHContext

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(searchScope))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(searchTerm))]) {
        return YES;
    }
    return [super propertyIsIgnored:propertyName];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(sorting))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(relationships))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(consumable))]
        || [propertyName isEqualToString:NSStringFromSelector(@selector(mediums))]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

+ (NSString*)protocolForArrayProperty:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(relationships))]) {
        return NSStringFromClass(MHRelationship.class);
    }
    else if ([propertyName isEqualToString:NSStringFromSelector(@selector(mediums))]) {
        return NSStringFromClass(MHSourceMedium.class);
    }
    return [super protocolForArrayProperty:propertyName];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError**)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        for (MHSourceMedium* medium in self.mediums) {
            medium.context = self;
        }
    }
    return self;
}

- (MHSourceMedium*)mediumForType:(NSString*)type
{
    id object = nil;
    for (MHSourceMedium* medium in self.mediums) {
        if ([medium.type isEqualToString:type]) {
            object = medium;
            break;
        }
    }
    
    if (object) {
        return (MHSourceMedium*)[[MHSimpleProxy alloc] initWithObject:object context:self];
    }
    else {
        return nil;
    }
}

- (NSArray*)allMediums
{
    NSMutableArray* proxiedMediums = [NSMutableArray array];
    
    for (MHSourceMedium* medium in self.mediums) {
        MHSimpleProxy* proxiedMedium = [[MHSimpleProxy alloc] initWithObject:medium
                                                                     context:self];
        [proxiedMediums addObject:proxiedMedium];
    }
    return proxiedMediums;
}

@end
