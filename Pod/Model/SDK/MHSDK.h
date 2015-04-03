//
//  MHSDK.h
//  CoreHound
//
//  Created by Dustin Bachrach on 4/1/15.
//
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

/**
 * The MHSDK is the singular place to configure the SDK.
 */
@interface MHSDK : NSObject

/**
 * Returns the shared SDK instance.
 * Use this instance to configure the SDK.
 */
+ (instancetype)sharedSDK;

/**
 * Configures the SDK for Application OAuth.
 * @param clientId Your application's client Id.
 * @param clientSecret Your application's client secret.
 * @return A Promise that resolves when configuration is complete.
 */
- (PMKPromise*)configureWithClientId:(NSString*)clientId
                        clientSecret:(NSString*)clientSecret;

@end
