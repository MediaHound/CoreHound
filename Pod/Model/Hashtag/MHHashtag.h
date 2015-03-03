//
//  MHHashtag.h
//  CoreHound
//
//  Created by Dustin Bachrach on 12/22/14.
//
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
