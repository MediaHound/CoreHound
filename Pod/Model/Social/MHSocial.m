//
//  MHSocial.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHSocial.h"
#import "MHObject+Internal.h"
#import "MHSourcePreference+Internal.h"


@implementation MHSocial

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (void)setPreferenceWithNSString:(NSString*)preferenceValue
{
    MHSourcePreference pref = MHSourcePreferenceFromNSString(preferenceValue);
    
    if (pref != self.userPreference) {
        self.userPreference = pref;
    }
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:MHSocial.class]) {
        return NO;
    }
    
    return [self isEqualToSocial:(MHSocial*)object];
}

- (BOOL)isEqualToSocial:(MHSocial*)social
{
    return ((!self.followers && !social.followers) || ([self.followers isEqual:social.followers]))
    && ((!self.likers && !social.likers) || ([self.likers isEqual:social.likers]))
    && ((!self.collectors && !social.collectors) || ([self.collectors isEqual:social.collectors]))
    && ((!self.mentioners && !social.mentioners) || ([self.mentioners isEqual:social.mentioners]))
    && ((!self.following && !social.following) || ([self.following isEqual:social.following]))
    && ((!self.ownedCollections && !social.ownedCollections) || ([self.ownedCollections isEqual:social.ownedCollections]))
    && ((!self.userLikes && !social.userLikes) || ([self.userLikes isEqual:social.userLikes]))
    && ((!self.userFollows && !social.userFollows) || ([self.userFollows isEqual:social.userFollows]))
    && ((!self.items && !social.items) || ([self.items isEqual:social.items]))
    && ((!self.isFeatured && !social.isFeatured) || ([self.isFeatured isEqual:social.isFeatured]))
    && ((!self.userConnected && !social.userConnected) || ([self.userConnected isEqual:social.userConnected]))
    && ((self.userPreference == social.userPreference));
}

- (NSUInteger)hash
{
    return self.followers.hash
        ^ self.likers.hash
        ^ self.collectors.hash
        ^ self.mentioners.hash
        ^ self.following.hash
        ^ self.ownedCollections.hash
        ^ self.userLikes.hash
        ^ self.userFollows.hash
        ^ self.items.hash
        ^ self.isFeatured.hash
        ^ self.userConnected.hash
        ^ self.userPreference;
}

@end
