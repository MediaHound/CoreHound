//
//  MHSourceMedium+Internal.h
//  CoreHound
//
//  Created by Dustin Bachrach on 1/21/15.
//
//

#import "MHSourceMedium.h"

@class MHSource;
@class MHObject;
@class MHContext;


@interface MHSourceMedium (Internal)

@property (weak, nonatomic, readwrite) MHSource<Ignore>* source;
@property (weak, nonatomic, readwrite) MHObject<Ignore>* content;

@property (weak, nonatomic) MHContext<Ignore>* context;

@end
