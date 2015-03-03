//
//  MHSourceMedium.m
//  Pods
//
//  Created by Dustin Bachrach on 1/21/15.
//
//

#import "MHSourceMedium.h"
#import "MHSourceMedium+Internal.h"
#import "MHSourceMethod+Internal.h"
#import "MHSimpleProxy.h"

#import <Underscore.m/Underscore.h>
@compatibility_alias _ Underscore;

NSString* const MHSourceMediumTypeStream = @"stream";
NSString* const MHSourceMediumTypeDownload = @"download";
NSString* const MHSourceMediumTypeDeliver = @"deliver";
NSString* const MHSourceMediumTypePickup = @"pickup";
NSString* const MHSourceMediumTypeAttend = @"attend";


@interface MHSourceMedium ()

@property (strong, nonatomic) NSArray<MHSourceMethod>* methods;

@property (weak, nonatomic, readwrite) MHSource<Ignore>* source;
@property (weak, nonatomic, readwrite) MHObject<Ignore>* content;
@property (weak, nonatomic) MHContext<Ignore>* context;

@end


@implementation MHSourceMedium

- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError**)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        for (MHSourceMethod* method in self.methods) {
            method.medium = self;
        }
    }
    return self;
}

- (MHSourceMethod*)methodForType:(NSString*)type
{
    id object = _.find(self.methods, ^BOOL(MHSourceMethod* m) {
        return [m.type isEqualToString:type];
    });
    return [[MHSimpleProxy alloc] initWithObject:object context:self.context];
}

- (NSArray*)allMethods
{
    return _.arrayMap(self.methods, ^(MHSourceMethod* m) {
        return [[MHSimpleProxy alloc] initWithObject:m context:self];
    });
}

@end
