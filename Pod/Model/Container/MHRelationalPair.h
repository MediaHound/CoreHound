//
//  MHRelationalPair.h
//  CoreHound
//
//  Copyright (c) 2015 Media Hound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MHSourceMedium.h"

@class MHObject;


@interface MHSorting : JSONModel

@property (strong, nonatomic) NSNumber<Optional>* importance;

@property (strong, nonatomic) NSNumber<Optional>* position;

@end


@protocol MHRelationship <NSObject>

@end


@interface MHRelationship : JSONModel

@property (strong, nonatomic) NSString* contribution;

@property (strong, nonatomic) NSString<Optional>* role;

@property (strong, nonatomic) MHObject<Optional>* object;

@end


@interface MHContext : JSONModel

@property (strong, nonatomic) MHSorting<Optional>* sorting;

@property (strong, nonatomic) NSArray<MHRelationship, Optional>* relationships;

@property (strong, nonatomic) NSNumber<Optional>* consumable;

- (MHSourceMedium*)mediumForType:(NSString*)type;

@property (strong, nonatomic, readonly) NSArray* allMediums;
//
// TODO: Should all contexts have a content pointer back to the object?
//       if so, then we should remove `content` from MHSourceMedium
//@property (strong, nonatomic, readonly) MHMedia* content;

@end


@protocol MHRelationalPair <NSObject>

@end


@interface MHRelationalPair : JSONModel

@property (strong, nonatomic) MHObject<Optional>* object;
@property (strong, nonatomic) MHContext<Optional>* context;

@end
