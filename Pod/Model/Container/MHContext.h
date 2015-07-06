//
//  MHContext.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <JSONModel/JSONModel.h>

#import "MHRelationship.h"
#import "MHSearchScope.h"

@class MHSourceMedium;
@class MHSorting;


/**
 * An MHContext includes arbitrary data about the context of MHObjects when returned in a MHRelationalPair.
 * For example, an MHShowEpisode has a `primaryGroup` property, which is an MHRelationalPair.
 * The `object` in the MHRelationalPair is the episode's MHShowSeason.
 * The `context` in the MHRelationalPair is information about what episode number this MHShowEpisode
 * was in this MHSShowSeason.
 */
@interface MHContext : JSONModel

/**
 * Sorting information on how this MHObject relates.
 */
@property (strong, nonatomic) MHSorting* sorting;

/**
 * An array of MHRelationships that express how a contributor contributed to content.
 */
@property (strong, nonatomic) NSArray* relationships;

/**
 * Whether this MHSource is consumable.
 */
@property (strong, nonatomic) NSNumber* consumable;

/** 
 * Get a medium for this MHSource of a specific type.
 * @param type The type of medium to get.
 * @return The source medium or nil if no medium for the given type is found.
 */
- (MHSourceMedium*)mediumForType:(NSString*)type;

/**
 * All mediums for this MHSource.
 */
@property (strong, nonatomic, readonly) NSArray* allMediums;

/**
 * The search term that was used to return this MHObject from search.
 */
@property (strong, nonatomic) NSString* searchTerm;

/**
 * The search scope that was used to return this MHObject from search.
 */
@property (nonatomic) MHSearchScope searchScope;

//
// TODO: Should all contexts have a content pointer back to the object?
//       if so, then we should remove `content` from MHSourceMedium
//@property (strong, nonatomic, readonly) MHMedia* content;

@end
