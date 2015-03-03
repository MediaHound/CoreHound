//
//  Social.h
//  mediaHound
//
//  Created by Dustin Bachrach on 5/30/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "JSONModel.h"
#import "MHSourcePreference.h"

// TODO: Deprecate this and get rid of it
extern NSString* const MHUserSourceDescriptionNone;
extern NSString* const MHUserSourceDescriptionStreaming;
extern NSString* const MHUserSourceDescriptionDelivery;
extern NSString* const MHUserSourceDescriptionBoth;


@interface MHSocial : JSONModel

@property (strong, nonatomic) NSNumber<Optional>* followers;
@property (strong, nonatomic) NSNumber<Optional>* likers;
@property (strong, nonatomic) NSNumber<Optional>* collectors;
@property (strong, nonatomic) NSNumber<Optional>* mentioners;

@property (strong, nonatomic) NSNumber<Optional>* following;
@property (strong, nonatomic) NSNumber<Optional>* ownedCollections;

@property (strong, nonatomic) NSNumber<Optional>* userLikes;
@property (strong, nonatomic) NSNumber<Optional>* userFollows;

@property (strong, nonatomic) NSNumber<Optional>* items;

@property (strong, nonatomic) NSNumber<Optional>* isFeatured;

@property (strong, nonatomic) NSNumber<Optional>* userConnected;
@property (nonatomic) MHSourcePreference userPreference;
@property (strong, nonatomic) NSString* userSourceDescription;

- (BOOL)isEqualToSocial:(MHSocial*)social;

@end
