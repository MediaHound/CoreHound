//
//  MHSubscription.h
//  CoreHound
//
//  Created by Dustin Bachrach on 1/21/15.
//
//

#import "MHObject.h"
#import "MHMetadata.h"


@protocol MHSubscription <NSObject>

@end


@interface MHSubscription : MHObject

@property (strong, nonatomic) MHSubscriptionMetadata* metadata;

- (NSString*)displayPrice;

@end