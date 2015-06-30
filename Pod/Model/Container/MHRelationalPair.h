//
//  MHRelationalPair.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MHJSONModelInternal.h"

@class MHObject;
@class MHContext;

MHJSONMODEL_PROTOCOL_DEFINE(MHRelationalPair)


/**
 * An MHRelationalPair represents an object with additional context.
 * Relational pairs are the contents of all MHPagedResponses.
 */
@interface MHRelationalPair : JSONModel

/**
 * The object
 */
@property (strong, nonatomic) MHObject* object;

/**
 * Context that relates `object` to the originating request.
 */
@property (strong, nonatomic) MHContext* context;

@end
