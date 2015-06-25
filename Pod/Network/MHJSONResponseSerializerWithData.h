//
//  MHJSONResponseSerializerWithData.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <AFNetworking/AFURLResponseSerialization.h>

/// NSError userInfo key that will contain response data
extern NSString* const MHJSONResponseSerializerWithDataKey;
extern NSString* const MHJSONResponseSerializerWithStringKey;


/**
 * http://blog.gregfiumara.com/archives/239
 */
@interface MHJSONResponseSerializerWithData : AFJSONResponseSerializer

@end
