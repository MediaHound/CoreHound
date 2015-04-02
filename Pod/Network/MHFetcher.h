//
//  MHFetcher.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>
#import <AvenueFetcher/AVEFetcher.h>


@interface MHFetcher : AVEFetcher

- (void)setBaseURL:(NSURL*)baseURL;

@end
