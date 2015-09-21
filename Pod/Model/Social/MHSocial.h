//
//  MHSocial.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MHSourcePreference.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * An MHSocial object contains all social metrics and user-specific 
 * social states for an MHObject.
 */
@interface MHSocial : JSONModel

/**
 * The number of users that follow this MHObject.
 */
@property (strong, nullable, nonatomic) NSNumber* followers;

/**
 * The number of users that like this MHObject.
 */
@property (strong, nullable, nonatomic) NSNumber* likers;

/**
 * The number of users that have collected this MHObject.
 */
@property (strong, nullable, nonatomic) NSNumber* collectors;

/**
 * The number of users that have mentioned this MHObject in an MHAction.
 */
@property (strong, nullable, nonatomic) NSNumber* mentioners;

/**
 * The number of users this MHUser is following.
 * @warning This property is only valid on an MHSocial object for an MHUser.
 */
@property (strong, nullable, nonatomic) NSNumber* following;

/**
 * The number of collections created by this MHUser.
 * @warning This property is only valid on an MHSocial object for an MHUser.
 */
@property (strong, nullable, nonatomic) NSNumber* ownedCollections;

/**
 * Whether the currently logged in user likes this MHObject.
 * @warning This property is only valid if there is a currently logged in user.
 */
@property (strong, nullable, nonatomic) NSNumber* userLikes;

/**
 * Whether the currently logged in user follows this MHObject.
 * @warning This property is only valid if there is a currently logged in user.
 */
@property (strong, nullable, nonatomic) NSNumber* userFollows;

/**
 * The number of items in this MHCollection.
 * @warning This property is only valid on an MHSocial object for an MHCollection.
 */
@property (strong, nullable, nonatomic) NSNumber* items;

/**
 * Whether or not this MHObject is featured.
 * Featured objects have been deemed featured by an Admin.
 */
@property (strong, nullable, nonatomic) NSNumber* isFeatured;

/**
 * Whether or not the currently logged in user is connected to this MHSource.
 * @warning This property is only valid if there is a currently logged in user.
 * @warning This property is only valid on an MHSocial object for an MHSource.
 */
@property (strong, nullable, nonatomic) NSNumber* userConnected;

/**
 * How preferred this MHSource is to the currently logged in user.
 * @warning This property is only valid if there is a currently logged in user.
 * @warning This property is only valid on an MHSocial object for an MHSource.
 */
@property (assign, nonatomic) MHSourcePreference userPreference;

/**
 * @param social The social object to compare to.
 * @return Whether this MHSocial is identical to another MHSocial object.
 */
- (BOOL)isEqualToSocial:(MHSocial*)social;

@end

NS_ASSUME_NONNULL_END
