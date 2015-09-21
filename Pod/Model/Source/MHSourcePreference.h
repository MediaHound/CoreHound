//
//  MHSourcePreference.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * User's source preference level indicates how important a source
 * is to a user. For example, a Netflix subscribe would likely indicate
 * that netflix is a Highly preferred source.
 */
typedef NS_ENUM(NSInteger, MHSourcePreference) {
    /**
     * User has not expressed a preference for this source.
     */
    MHSourcePreferenceNone,
    
    /**
     * User has expressed a low preference for this source.
     */
    MHSourcePreferenceLow,
    
    /**
     * User has not expressed a medium preference for this source.
     */
    MHSourcePreferenceMedium,
    
    /**
     * User has not expressed a high preference for this source.
     */
    MHSourcePreferenceHigh,
};
