//
//  MHSubscription.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"
#import "MHJSONModelInternal.h"

MHJSONMODEL_PROTOCOL_DEFINE(MHSubscription)


@interface MHSubscription : MHObject

@property (strong, atomic) MHSubscriptionMetadata* metadata;

- (NSString*)displayPrice;

@end