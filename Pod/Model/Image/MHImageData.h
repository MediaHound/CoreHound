//
//  MHImageData.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface MHImageData : JSONModel

@property (strong, nonatomic) NSString* url;

@property (strong, nonatomic) NSNumber* width;

@property (strong, nonatomic) NSNumber* height;

@end
