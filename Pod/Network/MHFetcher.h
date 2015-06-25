//
//  MHFetcher.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>
#import <AvenueFetcher/AVEFetcher.h>


@interface MHFetcher : AVEFetcher

- (void)setBaseURL:(NSURL*)baseURL;

@end
