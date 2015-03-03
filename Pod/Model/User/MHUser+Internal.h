//
//  MHUser+Internal.h
//  MediaHound
//
//  Created by Dustin Bachrach on 10/22/14.
//
//

#import "MHUser.h"


@interface MHUser (Internal)

- (void)invalidateOwnedCollections;
- (void)invalidateFollowing;

@end
