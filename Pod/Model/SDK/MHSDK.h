//
//  MHSDK.h
//  CoreHound
//
//  Created by Dustin Bachrach on 4/1/15.
//
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>


@interface MHSDK : NSObject

+ (instancetype)sharedSDK;

- (PMKPromise*)configureWithClientId:(NSString*)clientId
                 clientSecret:(NSString*)clientSecret;

@end
