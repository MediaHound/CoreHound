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


@interface MHRelationship : JSONModel

@property (strong, nonatomic) NSString* contribution;

@property (strong, nonatomic) NSString<Optional>* role;

@property (strong, nonatomic) MHObject<Optional>* object;

@end
