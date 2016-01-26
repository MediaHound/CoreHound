//
//  MHSDK.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * The MHSDK allows configuration of the SDK.
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
- (AnyPromise*)configureWithClientId:(NSString*)clientId
                        clientSecret:(NSString*)clientSecret;

@property (strong, nonatomic, readonly) NSString* apiVersion;

@end

NS_ASSUME_NONNULL_END
