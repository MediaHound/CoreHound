//
//  MHMetadata.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class MHImageData;


/**
 * Metadata about an `MHObject` object.
 */
@interface MHMetadata : JSONModel

/**
 * The unique MediaHound identifier for this object.
 */
@property (strong, nonatomic) NSString* mhid;

/**
 * The dispalyable name of this object.
 */
@property (strong, nonatomic) NSString* name;

/**
 * A description of this object.
 */
@property (strong, nonatomic) NSString* objectDescription;

/**
 * The date this object was created. 
 * This is typically valid for social objects to indicate
 * when the social action occured.
 * For dates related to Media content, consider the `releaseDate` property.
 */
@property (strong, nonatomic) NSDate* createdDate;

@end


/**
 * Metadata about an `MHMedia` object.
 */
@interface MHMediaMetadata : MHMetadata

/**
 * When the piece of media was publicly released.
 */
@property (strong, nonatomic) NSDate* releaseDate;

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
@property (nonatomic, strong) NSString* email;

@end


/**
 * Metadata about an `MHImage` object.
 */
@interface MHImageMetadata : MHMetadata

/**
 * An image representation at the original resolution.
 * Do not rely on the resolution for all originals to be the same or be fixed.
 */
@property (strong, nonatomic) MHImageData* original;

/**
 * An image representation at thumbnail resolution.
 * Do not rely on the resolution for all thumbnails to be the same or be fixed.
 */
@property (strong, nonatomic) MHImageData* thumbnail;

/**
 * An image representation at small resolution.
 * Do not rely on the resolution for all smalls to be the same or be fixed.
 */
@property (strong, nonatomic) MHImageData* small;

/**
 * An image representation at medium resolution.
 * Do not rely on the resolution for all mediums to be the same or be fixed.
 */
@property (strong, nonatomic) MHImageData* medium;

/**
 * An image representation at large resolution.
 * Do not rely on the resolution for all larges to be the same or be fixed.
 */
@property (strong, nonatomic) MHImageData* large;

/**
 * A boolean indicating whether this is a default image or not.
 * If true, the `url` property in each MHImageData will be the
 * default MediaHound image for that MHObject.
 * If you want to have custom default images, then check for this property
 * and load your own image instead.
 */
@property (strong, nonatomic) NSNumber* isDefault;

/**
 * The average color of the image.
 * NOTE: Currently unavailable.
 */
@property (strong, nonatomic) UIColor* averageColor;

@end


/**
 * Metadata about an `MHAction` object.
 */
@interface MHActionMetadata : MHMetadata

/**
 * The user-created message for an action.
 * Note: This property will only exist for `MHPost` objects.
 */
@property (strong, nonatomic) NSString* message;

@end


/**
 * What type of mixlist a collection is.
 */
typedef NS_ENUM(NSInteger, MHCollectionMixlistType)
{
    /**
     * This collection is not a mixlist.
     */
    MHCollectionMixlistTypeNone,
    
    /** 
     * This collection is a partial mixlist.
     */
    MHCollectionMixlistTypePartial,
    
    /**
     * This collection is a fully complete mixlist.
     */
    MHCollectionMixlistTypeFull,
};


/**
 * Metadata about an `MHCollection` object.
 */
@interface MHCollectionMetadata : MHMetadata

/**
 * What type of a mixlist this collection is.
 */
@property (assign, nonatomic) MHCollectionMixlistType mixlist;

@end


/**
 * Metadata about an `MHSubscription` object.
 */
@interface MHSubscriptionMetadata : MHMetadata

/**
 * How long this subscription lasts.
 * E.g.: @"monthly"
 */
@property (strong, nonatomic) NSString* timePeriod;

/**
 * The numeric price for this subscription.
 */
@property (strong, nonatomic) NSNumber* price;

/**
 * The currency of the `price`.
 */
@property (strong, nonatomic) NSString* currency;

/**
 * An array of mediums this subscription supports.
 * See `MHSourceMedium`.
 */
@property (strong, nonatomic) NSArray* mediums;

@end

/**
 * Metadata about an `MHSource` object.
 */
@interface MHSourceMetadata : MHMetadata

/**
 * Whether the user can connect to this source.
 */
@property (strong, nonatomic) NSNumber* connectable;

@end
