//
//  MHSourceMethod.h
//  CoreHound
//
//  Created by Dustin Bachrach on 1/21/15.
//
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