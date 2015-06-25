//
//  MHSourcePreference.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
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
