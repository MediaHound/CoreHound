//
//  MHSourceMedium.m
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHSourceMedium.h"
#import "MHSourceMedium+Internal.h"
#import "MHSourceMethod+Internal.h"
#import "MHSimpleProxy.h"

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
    id object = nil;
    for (MHSourceMethod* method in self.methods) {
        if ([method.type isEqualToString:type]) {
            object = method;
            break;
        }
    }
    
    if (object) {
        return (MHSourceMethod*)[[MHSimpleProxy alloc] initWithObject:object context:self.context];
    }
    else {
        return nil;
    }
}

- (NSArray*)allMethods
{
    NSMutableArray* proxiedMethods = [NSMutableArray array];
    
    for (MHSourceMethod* method in self.methods) {
        MHSimpleProxy* proxiedMethod = [[MHSimpleProxy alloc] initWithObject:method
                                                                     context:self.context];
        [proxiedMethods addObject:proxiedMethod];
    }
    return proxiedMethods;
}

@end
