//
//  MHTrait.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHObject.h"
#import "MHMetadata.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * An MHTrait provides a descriptor about media content.
 */
@interface MHTrait : MHObject

/**
 * Metadata about the receiver
 * This property is guranteed to exist.
 */
@property (strong, atomic) MHTraitMetadata* metadata;

@end

NS_ASSUME_NONNULL_END
