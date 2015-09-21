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

NS_ASSUME_NONNULL_BEGIN


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
@property (strong, nullable, nonatomic) MHSorting* sorting;

/**
 * An array of MHRelationships that express how a contributor contributed to content.
 */
@property (strong, nullable, nonatomic) NSArray* relationships;

/**
 * Whether this MHSource is consumable.
 */
@property (strong, nullable, nonatomic) NSNumber* consumable;

/** 
 * Get a medium for this MHSource of a specific type.
 * @param type The type of medium to get.
 * @return The source medium or nil if no medium for the given type is found.
 */
- (nullable MHSourceMedium*)mediumForType:(NSString*)type;

/**
 * All mediums for this MHSource.
 */
@property (strong, nullable, nonatomic, readonly) NSArray* allMediums;

/**
 * The search term that was used to return this MHObject from search.
 */
@property (strong, nullable, nonatomic) NSString* searchTerm;

/**
 * The search scope that was used to return this MHObject from search.
 */
@property (assign, nonatomic) MHSearchScope searchScope;

@end

NS_ASSUME_NONNULL_END
