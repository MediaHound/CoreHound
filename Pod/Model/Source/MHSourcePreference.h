//
//  MHSourcePreference.h
//  CoreHound
//
//  Created by Dustin Bachrach on 1/30/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MHSourcePreference) {
    MHSourcePreferenceNone,
    MHSourcePreferenceLow,
    MHSourcePreferenceMedium,
    MHSourcePreferenceHigh,
};

NSString * NSStringFromMHSourcePreference(MHSourcePreference preference);
MHSourcePreference MHSourcePreferenceFromNSString(NSString * preferenceValue);
