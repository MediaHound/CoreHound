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

@property (strong, nonatomic) NSArray<MHSourceMedium, Optional>* mediums;

@end


@implementation MHContext

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
