//
//  MHSubscription.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHObject.h"


@protocol MHSubscription <NSObject>

@end


@interface MHSubscription : MHObject

@property (strong, atomic) MHSubscriptionMetadata* metadata;

- (NSString*)displayPrice;

@end