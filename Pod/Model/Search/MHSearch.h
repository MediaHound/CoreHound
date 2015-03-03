//
//  MHSearch.h
//  CoreHound
//
//  Created by Dustin Bachrach on 2/26/15.
//
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <Avenue/Avenue.h>
#import "AutocompleteResult.h"

@class MHPagingInfo;


@interface MHSearch : NSObject

+ (PMKPromise*)fetchResultsForSearchTerm:(NSString*)search
                                   scope:(NSString*)scope
                                priority:(AVENetworkPriority*)priority
                            networkToken:(AVENetworkToken*)networkToken;

@end


typedef PMKPromise*(^MHPagedSearchResponseFetchNextBlock)(NSString*);


// Would be nice to have this use MHPagedResponse
// In mh, extend this with protocol: MHRequesterPagedResponse
@interface MHPagedSearchResponse : JSONModel

@property (strong, nonatomic) NSArray<AutocompleteResult>* content;
@property (strong, nonatomic) MHPagingInfo<Optional>* pagingInfo;
@property (strong, nonatomic) NSNumber* number;
@property (strong, nonatomic) NSNumber* totalPages;
@property (nonatomic, readonly) BOOL hasMorePages;

// TODO: Internal
@property (copy, nonatomic) MHPagedSearchResponseFetchNextBlock fetchNextOperation;

- (PMKPromise*)fetchNext;

@end
