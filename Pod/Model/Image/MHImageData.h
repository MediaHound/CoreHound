//
//  MHImageData.h
//  Pods
//
//  Created by Dustin Bachrach on 12/22/14.
//
//

#import "JSONModel.h"


@interface MHImageData : JSONModel

@property (strong, nonatomic) NSString* url;

@property (strong, nonatomic) NSNumber* width;

@property (strong, nonatomic) NSNumber* height;

@end
