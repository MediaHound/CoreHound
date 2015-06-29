//
//  MHJSONResponseSerializerWithData.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHJSONResponseSerializerWithData.h"
#import "MHError.h"


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
