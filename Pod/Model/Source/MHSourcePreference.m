//
//  MHSourcePreference.m
//  CoreHound
//
//  Created by Dustin Bachrach on 1/30/15.
//
//

#import "MHSourcePreference.h"

static NSString* const kSourceValueNone = @"none";
static NSString* const kSourceValueLow = @"low";
static NSString* const kSourceValueMedium = @"medium";
static NSString* const kSourceValueHigh = @"high";

NSString* NSStringFromMHSourcePreference(MHSourcePreference preference)
{
    NSDictionary* preferenceMapping = @{
                                        @(MHSourcePreferenceNone): kSourceValueNone,
                                        @(MHSourcePreferenceLow): kSourceValueLow,
                                        @(MHSourcePreferenceMedium): kSourceValueMedium,
                                        @(MHSourcePreferenceHigh): kSourceValueHigh
                                        };
    NSString* preferenceString = preferenceMapping[@(preference)];
    return preferenceString;
}

MHSourcePreference MHSourcePreferenceFromNSString(NSString* preferenceValue)
{
    NSDictionary* preferenceMapping = @{
                                        kSourceValueNone: @(MHSourcePreferenceNone),
                                        kSourceValueLow: @(MHSourcePreferenceLow),
                                        kSourceValueMedium: @(MHSourcePreferenceMedium),
                                        kSourceValueHigh: @(MHSourcePreferenceHigh)
                                        };
    NSNumber* pref = preferenceMapping[preferenceValue];
    if (!pref) {
        return MHSourcePreferenceNone;
    }
    else {
        return pref.integerValue;
    }
}