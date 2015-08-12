//
//  MHSourceMedium.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MHSourceMethod.h"

@class MHSource;
@class MHObject;

NS_ASSUME_NONNULL_BEGIN

extern NSString* const MHSourceMediumTypeStream;
extern NSString* const MHSourceMediumTypeDownload;
extern NSString* const MHSourceMediumTypeDeliver;
extern NSString* const MHSourceMediumTypePickup;
extern NSString* const MHSourceMediumTypeAttend;


@interface MHSourceMedium : JSONModel

@property (strong, nonatomic) NSString* type;

@property (weak, nonatomic, readonly) MHSource* source;
@property (weak, nonatomic, readonly) MHObject* __nullable content;

- (MHSourceMethod* __nullable)methodForType:(NSString*)type;

@property (strong, nonatomic, readonly) NSArray* allMethods;

@end

NS_ASSUME_NONNULL_END
