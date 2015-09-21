//
//  MHUser+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHUser.h"


@interface MHUser (Internal)

- (void)invalidateOwnedCollections;
- (void)invalidateFollowing;

@end
