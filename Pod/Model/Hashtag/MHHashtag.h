//
//  MHHashtag.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHObject.h"


@interface MHHashtag : MHObject

@end


@interface MHHashtag (Fetching)

+ (PMKPromise*)fetchByName:(NSString*)name;
+ (PMKPromise*)fetchByName:(NSString*)name
                  priority:(AVENetworkPriority*)priority
              networkToken:(AVENetworkToken*)networkToken;

@end
