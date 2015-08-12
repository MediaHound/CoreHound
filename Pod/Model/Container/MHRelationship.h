//
//  MHRelationship.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <JSONModel/JSONModel.h>

@class MHObject;

NS_ASSUME_NONNULL_BEGIN


/**
 * A relationship expresses how an MHContributor contributed to a piece of content.
 */
@interface MHRelationship : JSONModel

/**
 * What type of contribution. E.g. "Producer", "Director", "Actor".
 */
@property (strong, nonatomic) NSString* __nullable contribution;

/**
 * If the `contribution` was "Actor", then the `role` may contain the name of the
 * character they played. E.g. "Security Guard", "Young Anakin Skywalker".
 */
@property (strong, nonatomic) NSString* __nullable role;

/**
 * If the `contribution` was "Actor", then the `object` may contain the fictional
 * contributor they played. E.g. the Batman fictional contributor.
 */
@property (strong, nonatomic) MHObject* __nullable object;

@end

NS_ASSUME_NONNULL_END
