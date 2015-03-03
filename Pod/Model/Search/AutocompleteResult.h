//
//  AutocompleteResult.h
//  CoreHound
//
//  Created by Dustin Bachrach on 2/26/15.
//
//

#import <JSONModel/JSONModel.h>


@protocol AutocompleteResult

@end


@interface AutocompleteResult : JSONModel

@property (strong, nonatomic) NSString<Ignore>* searchTerm;
@property (strong, nonatomic) NSString<Ignore>* scope;

@property (strong, nonatomic) NSURL<Optional>* primaryImageUrl;
@property (strong, nonatomic) NSString* mhid;
@property (strong, nonatomic) NSString<Optional>* name;
@property (strong, nonatomic) NSDate<Optional>* releaseDate;
@property (strong, nonatomic) NSString<Optional>* username;
@property (strong, nonatomic) NSString<Optional>* user;
@property (strong, nonatomic) NSArray<Optional>* contributorNames;
@property (strong, nonatomic) NSArray<Optional>* contentImageUrls;

@end
