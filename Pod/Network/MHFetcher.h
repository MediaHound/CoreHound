//
//  MHFetcher.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>
#import <AvenueFetcher/AVEFetcher.h>


/**
 * The main fetcher for all MediaHound API calls
 */
@interface MHFetcher : AVEFetcher

/**
 * Set the base URL for all MediaHound API calls.
 * You should typically not need to use this method.
 * @param baseURL The new base URL for all API calls
 */
- (void)setBaseURL:(NSURL*)baseURL;

@end
