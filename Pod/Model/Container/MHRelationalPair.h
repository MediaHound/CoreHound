//
//  MHRelationalPair.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class MHObject;
@class MHContext;


@protocol MHRelationalPair <NSObject>

@end


@interface MHRelationalPair : JSONModel

@property (strong, nonatomic) MHObject<Optional>* object;
@property (strong, nonatomic) MHContext<Optional>* context;

@end
