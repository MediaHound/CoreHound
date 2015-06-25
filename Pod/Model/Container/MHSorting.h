//
//  MHSorting.h
//  CoreHound
//
//  Created by Dustin Bachrach on 6/24/15.
//
//

#import <JSONModel/JSONModel.h>


@interface MHSorting : JSONModel

@property (strong, nonatomic) NSNumber<Optional>* importance;

@property (strong, nonatomic) NSNumber<Optional>* position;

@end
