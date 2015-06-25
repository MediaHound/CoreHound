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

extern NSString* const MHSourceMediumTypeStream;
extern NSString* const MHSourceMediumTypeDownload;
extern NSString* const MHSourceMediumTypeDeliver;
extern NSString* const MHSourceMediumTypePickup;
extern NSString* const MHSourceMediumTypeAttend;


@protocol MHSourceMedium <NSObject>

@end


@interface MHSourceMedium : JSONModel

@property (strong, nonatomic) NSString* type;

@property (weak, nonatomic, readonly) MHSource<Ignore>* source;
@property (weak, nonatomic, readonly) MHObject<Ignore>* content;

- (MHSourceMethod*)methodForType:(NSString*)type;

@property (strong, nonatomic, readonly) NSArray* allMethods;

@end