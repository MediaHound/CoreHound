//
//  MHJSONResponseSerializerWithData.m
//  mediaHound
//
//  Created by Dustin Bachrach on 5/20/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHJSONResponseSerializerWithData.h"

NSString* const MHJSONResponseSerializerWithDataKey = @"MHJSONResponseSerializerWithDataKey";
NSString* const MHJSONResponseSerializerWithStringKey = @"MHJSONResponseSerializerWithStringKey";


@implementation MHJSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse*)response
                           data:(NSData*)data
                          error:(NSError* __autoreleasing *)error
{
	id JSONObject = [super responseObjectForResponse:response data:data error:error];
	if (*error != nil) {
		NSMutableDictionary* userInfo = [(*error).userInfo mutableCopy];
		if (data == nil) {
            userInfo[MHJSONResponseSerializerWithDataKey] = [NSData data];
            userInfo[MHJSONResponseSerializerWithStringKey] = @"";
		}
        else {
            userInfo[MHJSONResponseSerializerWithDataKey] = data;
            userInfo[MHJSONResponseSerializerWithStringKey] = [[NSString alloc] initWithData:data
                                                                                encoding:NSUTF8StringEncoding];
		}
		NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
		*error = newError;
	}
    
	return JSONObject;
}

@end
