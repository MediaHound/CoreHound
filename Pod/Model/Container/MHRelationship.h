//
//  MHRelationship.h
//  CoreHound
//
//  Created by Dustin Bachrach on 6/24/15.
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
