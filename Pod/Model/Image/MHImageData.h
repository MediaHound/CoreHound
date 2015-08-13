//
//  MHImageData.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN


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
@property (strong, nullable, nonatomic) NSNumber* width;

/**
 * The height of the image, in pixels.
 */
@property (strong, nullable, nonatomic) NSNumber* height;

@end

NS_ASSUME_NONNULL_END
