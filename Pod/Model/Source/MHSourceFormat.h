//
//  MHSourceFormat.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class MHSourceMethod;

NS_ASSUME_NONNULL_BEGIN

extern NSString* const MHSourceFormatLaunchInfoViewKey;
extern NSString* const MHSourceFormatLaunchInfoConsumeKey;
extern NSString* const MHSourceFormatLaunchInfoPreviewKey;
extern NSString* const MHSourceFormatLaunchInfoSourceIdKey;
extern NSString* const MHSourceFormatLaunchInfoViewTypeIOSKey;
extern NSString* const MHSourceFormatLaunchInfoViewTypeHTTPKey;

extern NSString* const MHSourceFormatTypeUnknownKey;


@interface MHSourceFormat : JSONModel

@property (strong, nonatomic) NSString* type;
@property (strong, nullable, nonatomic) NSNumber* price;
@property (strong, nullable, nonatomic) NSString* currency;
@property (strong, nullable, nonatomic) NSString* timePeriod;
@property (strong, nullable, nonatomic) NSNumber* contentCount;
@property (strong, nonatomic) NSDictionary* launchInfo;

@property (weak, nonatomic, readonly) MHSourceMethod* method;

@property (strong, nonatomic, readonly) NSString* displayPrice;

@end

NS_ASSUME_NONNULL_END
