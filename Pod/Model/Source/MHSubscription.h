//
//  MHSubscription.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"


@protocol MHSubscription <NSObject>

@end


@interface MHSubscription : MHObject

@property (strong, atomic) MHSubscriptionMetadata* metadata;

- (NSString*)displayPrice;

@end