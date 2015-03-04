//
//  MHImageData.h
//  CoreHound
//
//  Created by Dustin Bachrach on 12/22/14.
//
//

#import <JSONModel/JSONModel.h>


@interface MHImageData : JSONModel

@property (strong, nonatomic) NSString* url;

@property (strong, nonatomic) NSNumber* width;

@property (strong, nonatomic) NSNumber* height;

@end
