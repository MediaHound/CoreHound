//
//  MHMetadata.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <JSONModel/JSONModel.h>


/**
 * Metadata about an `MHObject` object.
 */
@interface MHMetadata : JSONModel

/**
 * The unique MediaHound identifier for this object.
 */
@property (strong, nonatomic) NSString* mhid;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSString<Optional>* objectDescription;
@property (nonatomic, strong) NSDate<Optional>* createdDate;

@end


/**
 * Metadata about an `MHMedia` object.
 */
@interface MHMediaMetadata : MHMetadata

/**
 * When the piece of media was publicly released.
 */
@property (strong, nonatomic) NSDate<Optional>* releaseDate; // TODO: Should not be optional

@end


/**
 * Metadata about an `MHUser` object.
 */
@interface MHUserMetadata : MHMetadata

/**
 * The user's username.
 * Note: Does not include an *@* sign at the beginning.
 */
@property (nonatomic, strong) NSString* username;

/**
 * The user's email address.
 * The email address is only populated for the currently logged-in user.
 */
@property (nonatomic, strong) NSString<Optional>* email;

@end


/**
 * Metadata about an `MHImage` object.
 */
@interface MHImageMetadata : MHMetadata

/**
 * A boolean indicating whether this is a default image or not.
 * If true, the `url` property in each MHImageData will be the
 * default MediaHound image for that MHObject.
 * If you want to have custom default images, then check for this property
 * and load your own image instead.
 */
@property (strong, nonatomic) NSNumber<Optional>* isDefault;

@property (strong, nonatomic) UIColor<Optional>* averageColor;

@end


/**
 * Metadata about an `MHAction` object.
 */
@interface MHActionMetadata : MHMetadata

/**
 * The user-created message for an action.
 * Note: This property will only exist for `MHPost` objects.
 */
@property (strong, nonatomic) NSString<Optional>* message;

@end



typedef NS_ENUM(NSInteger, MHCollectionMixlistType)
{
    MHCollectionMixlistTypeNone,
    MHCollectionMixlistTypePartial,
    MHCollectionMixlistTypeFull,
};


/**
 * Metadata about an `MHCollection` object.
 */
@interface MHCollectionMetadata : MHMetadata

@property (nonatomic) MHCollectionMixlistType mixlist;

@end


/**
 * Metadata about an `MHSubscription` object.
 */
@interface MHSubscriptionMetadata : MHMetadata

@property (strong, nonatomic) NSString* timePeriod;
@property (strong, nonatomic) NSNumber* price;
@property (strong, nonatomic) NSString* currency;
@property (strong, nonatomic) NSArray* mediums;

@end
