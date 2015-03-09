//
//  MHUser+Internal.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHUser.h"


@interface MHUser (Internal)

- (void)invalidateOwnedCollections;
- (void)invalidateFollowing;

@end
