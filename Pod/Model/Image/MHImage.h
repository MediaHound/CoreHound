//
//  MHImage.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"


/**
 * An MHImage is a visual representaiton of an object in The Entertainment Graph.
 * MHImages, themselves, are MHObjects so they can receive social actions.
 */
@interface MHImage : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHImageMetadata* metadata;

@end
