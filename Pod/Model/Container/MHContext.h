//
//  MHContext.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <JSONModel/JSONModel.h>

#import "MHRelationship.h"

@class MHSourceMedium;
@class MHSorting;


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
