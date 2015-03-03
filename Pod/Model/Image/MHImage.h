//
//  MHImage.h
//  mediaHound
//
//  Created by Dustin Bachrach on 9/2/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHObject.h"

@class MHImageMetadata;
@class MHImageData;


@interface MHImage : MHObject

@property (strong, atomic) MHImageMetadata* metadata;

@property (strong, nonatomic) MHImageData<Optional>* original;

@property (strong, nonatomic) MHImageData<Optional>* thumbnail;

@property (strong, nonatomic) MHImageData<Optional>* small;

@property (strong, nonatomic) MHImageData<Optional>* medium;

@property (strong, nonatomic) MHImageData<Optional>* large;

@end
