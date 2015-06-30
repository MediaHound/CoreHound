//
//  MHRelationship.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <JSONModel/JSONModel.h>
#import "MHJSONModelInternal.h"

@class MHObject;

MHJSONMODEL_PROTOCOL_DEFINE(MHRelationship)


/**
 * A relationship expresses how an MHContributor contributed to a piece of content.
 */
@interface MHRelationship : JSONModel

/**
 * What type of contribution. E.g. "Producer", "Director", "Actor".
 */
@property (strong, nonatomic) NSString* contribution;

/**
 * If the `contribution` was "Actor", then the `role` may contain the name of the
 * character they played. E.g. "Security Guard", "Young Anakin Skywalker".
 */
@property (strong, nonatomic) NSString* role;

/**
 * If the `contribution` was "Actor", then the `object` may contain the fictional
 * contributor they played. E.g. the Batman fictional contributor.
 */
@property (strong, nonatomic) MHObject* object;

@end
