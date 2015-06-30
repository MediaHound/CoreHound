//
//  MHImageData.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>


/**
 * An MHImageData represents the data for a specific MHImage at a specific resoultion.
 * It contains the width and height, in pixels as well as a URL to the image.
 */
@interface MHImageData : JSONModel

/**
 * A URL to access the image resouce.
 */
@property (strong, nonatomic) NSString* url;

/**
 * The width of the image, in pixels.
 */
@property (strong, nonatomic) NSNumber* width;

/**
 * The height of the image, in pixels.
 */
@property (strong, nonatomic) NSNumber* height;

@end
