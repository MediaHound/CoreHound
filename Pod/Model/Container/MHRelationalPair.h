//
//  MHRelationalPair.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class MHObject;
@class MHContext;

NS_ASSUME_NONNULL_BEGIN


/**
 * An MHRelationalPair represents an object with additional context.
 * Relational pairs are the contents of all MHPagedResponses.
 */
@interface MHRelationalPair : JSONModel

/**
 * The object
 */
@property (strong, nullable, nonatomic) MHObject* object;

/**
 * Context that relates `object` to the originating request.
 */
@property (strong, nullable, nonatomic) MHContext* context;

@end

NS_ASSUME_NONNULL_END
