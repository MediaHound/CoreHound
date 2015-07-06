//
//  MHSourceMethod.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MHSourceFormat.h"

@class MHSourceMedium;

extern NSString* const MHSourceMethodTypePurchase;
extern NSString* const MHSourceMethodTypeRental;
extern NSString* const MHSourceMethodTypeSubscription;
extern NSString* const MHSourceMethodTypeAdSupported;
extern NSString* const MHSourceMethodTypeBroker;


@interface MHSourceMethod : JSONModel

@property (strong, nonatomic) NSString* type;

@property (weak, nonatomic, readonly) MHSourceMedium* medium;

@property (strong, nonatomic, readonly) NSString* displayName;

- (MHSourceFormat*)formatForType:(NSString*)type;

@property (strong, nonatomic, readonly) MHSourceFormat* defaultFormat;

@property (strong, nonatomic, readonly) NSArray* allFormats;

@end
