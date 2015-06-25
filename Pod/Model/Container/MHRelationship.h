//
//  MHRelationship.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <JSONModel/JSONModel.h>

@class MHObject;


@protocol MHRelationship <NSObject>

@end


@interface MHRelationship : JSONModel

@property (strong, nonatomic) NSString* contribution;

@property (strong, nonatomic) NSString<Optional>* role;

@property (strong, nonatomic) MHObject<Optional>* object;

@end
