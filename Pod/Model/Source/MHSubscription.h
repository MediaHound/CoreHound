//
//  MHSubscription.h
//  CoreHound
//
//  Created by Dustin Bachrach on 1/21/15.
//
//

#import "MHObject.h"


@protocol MHSubscription <NSObject>

@end


@interface MHSubscription : MHObject

@property (strong, atomic) MHSubscriptionMetadata* metadata;

- (NSString*)displayPrice;

@end