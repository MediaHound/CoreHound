//
//  MHSourceMethod.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MHSourceFormat.h"

@class MHSourceMedium;

extern NSString* const MHSourceMethodTypePurchase;
extern NSString* const MHSourceMethodTypeRental;
extern NSString* const MHSourceMethodTypeSubscription;
extern NSString* const MHSourceMethodTypeAdSupported;


@protocol MHSourceMethod <NSObject>

@end


@interface MHSourceMethod : JSONModel

@property (strong, nonatomic) NSString* type;

@property (weak, nonatomic, readonly) MHSourceMedium<Ignore>* medium;

@property (strong, nonatomic, readonly) NSString* displayName;

- (MHSourceFormat*)formatForType:(NSString*)type;

@property (strong, nonatomic, readonly) MHSourceFormat* defaultFormat;

@property (strong, nonatomic, readonly) NSArray* allFormats;

@end