//
//  MHFetcher.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>
#import <AvenueFetcher/AVEFetcher.h>


/**
 * The main fetcher for all MediaHound API network requests.
 */
@interface MHFetcher : AVEFetcher

/**
 * Set the base URL for all MediaHound API calls.
 * You should typically not need to use this method.
 * @warning This method must be called before a call to `[MHSDK configureWithClientId:clientSecret:]`.
 * @param baseURL The new base URL for all API calls
 */
- (void)setBaseURL:(NSURL*)baseURL;

@end
