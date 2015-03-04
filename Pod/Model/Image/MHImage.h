//
//  MHImage.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import "MHObject.h"

@class MHImageData;


@interface MHImage : MHObject

@property (strong, atomic) MHImageMetadata* metadata;

@property (strong, nonatomic) MHImageData<Optional>* original;

@property (strong, nonatomic) MHImageData<Optional>* thumbnail;

@property (strong, nonatomic) MHImageData<Optional>* small;

@property (strong, nonatomic) MHImageData<Optional>* medium;

@property (strong, nonatomic) MHImageData<Optional>* large;

@end
