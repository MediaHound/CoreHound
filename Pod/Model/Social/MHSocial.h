//
//  MHSocial.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MHSourcePreference.h"

NS_ASSUME_NONNULL_BEGIN

// TODO: Deprecate this and get rid of it
extern NSString* const MHUserSourceDescriptionNone;
extern NSString* const MHUserSourceDescriptionStreaming;
extern NSString* const MHUserSourceDescriptionDelivery;
extern NSString* const MHUserSourceDescriptionBoth;


/**
 * An MHSocial object contains all social metrics and user-specific 
 * social states for an MHObject.
 */
@interface MHSocial : JSONModel

/**
 * The number of users that follow this MHObject.
 */
@property (strong, nonatomic) NSNumber* __nullable followers;

/**
 * The number of users that like this MHObject.
 */
@property (strong, nonatomic) NSNumber* __nullable likers;

/**
 * The number of users that have collected this MHObject.
 */
@property (strong, nonatomic) NSNumber* __nullable collectors;

/**
 * The number of users that have mentioned this MHObject in an MHAction.
 */
@property (strong, nonatomic) NSNumber* __nullable mentioners;

/**
 * The number of users this MHUser is following.
 * @warning This property is only valid on an MHSocial object for an MHUser.
 */
@property (strong, nonatomic) NSNumber* __nullable following;

/**
 * The number of collections created by this MHUser.
 * @warning This property is only valid on an MHSocial object for an MHUser.
 */
@property (strong, nonatomic) NSNumber* __nullable ownedCollections;

/**
 * Whether the currently logged in user likes this MHObject.
 * @warning This property is only valid if there is a currently logged in user.
 */
@property (strong, nonatomic) NSNumber* __nullable userLikes;

/**
 * Whether the currently logged in user follows this MHObject.
 * @warning This property is only valid if there is a currently logged in user.
 */
@property (strong, nonatomic) NSNumber* __nullable userFollows;

/**
 * The number of items in this MHCollection.
 * @warning This property is only valid on an MHSocial object for an MHCollection.
 */
@property (strong, nonatomic) NSNumber* __nullable items;

/**
 * Whether or not this MHObject is featured.
 * Featured objects have been deemed featured by an Admin.
 */
@property (strong, nonatomic) NSNumber* __nullable isFeatured;

/**
 * Whether or not the currently logged in user is connected to this MHSource.
 * @warning This property is only valid if there is a currently logged in user.
 * @warning This property is only valid on an MHSocial object for an MHSource.
 */
@property (strong, nonatomic) NSNumber* __nullable userConnected;

/**
 * How preferred this MHSource is to the currently logged in user.
 * @warning This property is only valid if there is a currently logged in user.
 * @warning This property is only valid on an MHSocial object for an MHSource.
 */
@property (assign, nonatomic) MHSourcePreference userPreference;

// TODO: Remove. Deprecated.
@property (strong, nonatomic) NSString* userSourceDescription;

/**
 * @param social The social object to compare to.
 * @return Whether this MHSocial is identical to another MHSocial object.
 */
- (BOOL)isEqualToSocial:(MHSocial*)social;

@end

NS_ASSUME_NONNULL_END
