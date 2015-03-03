//
//  MHRelationalPair.m
//  mediaHound
//
//  Created by Dustin Bachrach on 6/23/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHRelationalPair.h"
#import "MHSimpleProxy.h"
#import "MHSourceMedium+Internal.h"

#import <Underscore.m/Underscore.h>
@compatibility_alias _ Underscore;


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
    id object = _.find(self.mediums, ^BOOL(MHSourceMedium* m) {
        return [m.type isEqualToString:type];
    });
    
    return (MHSourceMedium*)[[MHSimpleProxy alloc] initWithObject:object context:self];
}

- (NSArray*)allMediums
{
    return _.arrayMap(self.mediums, ^(MHSourceMedium* m) {
        return [[MHSimpleProxy alloc] initWithObject:m context:self];
    });
}

@end


@implementation MHRelationship

@end


@implementation MHSorting

@end


@implementation MHRelationalPair

@end
