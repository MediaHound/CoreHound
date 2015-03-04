//
//  MHSourceFormat.h
//  CoreHound
//
//  Created by Dustin Bachrach on 1/21/15.
//
//

#import <JSONModel/JSONModel.h>

@class MHSourceMethod;

extern NSString* const MHSourceFormatLaunchInfoViewKey;
extern NSString* const MHSourceFormatLaunchInfoConsumeKey;
extern NSString* const MHSourceFormatLaunchInfoPreviewKey;
extern NSString* const MHSourceFormatLaunchInfoSourceIdKey;
extern NSString* const MHSourceFormatLaunchInfoViewTypeIOSKey;
extern NSString* const MHSourceFormatLaunchInfoViewTypeHTTPKey;

extern NSString* const MHSourceFormatTypeUnknownKey;


@protocol MHSourceFormat <NSObject>

@end


@interface MHSourceFormat : JSONModel

@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSNumber<Optional>* price;
@property (strong, nonatomic) NSString<Optional>* currency;
@property (strong, nonatomic) NSString<Optional>* timePeriod;
@property (strong, nonatomic) NSDictionary* launchInfo;

@property (weak, nonatomic, readonly) MHSourceMethod<Ignore>* method;

@property (strong, nonatomic, readonly) NSString* displayPrice;

@end