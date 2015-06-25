//
//  MHSorting.h
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//
//

#import <JSONModel/JSONModel.h>


/**
 * An MHSorting will appear inside of an MHContext indicating how the MHObject should be sorted
 * relative to other objects in the results.
 * Since there are multiple ways to sort results, MHSorting allows you to see how an object
 * should be positioned in different types of sorting.
 */
@interface MHSorting : JSONModel

/**
 * The importance of this MHObject compared to other MHObjects in the result.
 */
@property (strong, nonatomic) NSNumber<Optional>* importance;

/**
 * The raw positional order of this MHObject compared to other MHObjects in the result.
 */
@property (strong, nonatomic) NSNumber<Optional>* position;

@end
