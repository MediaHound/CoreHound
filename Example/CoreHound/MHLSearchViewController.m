//
//  MHLSearchViewController.m
//  CoreHound
//
//  Created by Dustin Bachrach on 03/02/2015.
//  Copyright (c) 2014 Dustin Bachrach. All rights reserved.
//

#import "MHLSearchViewController.h"

#import <CoreHound/MHApi.h>

#import "MHLCells.h"
#import "MHLResultViewController.h"


@interface MHLSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar* MHSDKSearch;
@property (weak, nonatomic) IBOutlet UIImageView *mediaHoundLogo;
@property (weak, nonatomic) IBOutlet UIImageView *mediaHoundTitle;
@property (weak, nonatomic) IBOutlet UILabel *searchLiteLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) MHPagedResponse* response;
@property (strong, nonatomic) NSMutableArray* allSearchResults;
@property (assign, nonatomic) BOOL additionalSearchPages;

@end


@implementation MHLSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"Search Lite";
    self.searchBar.placeholder = @"Search the Graph";
    self.additionalSearchPages = NO;

    if ([[UIScreen mainScreen] bounds].size.height <= 500) {
        self.mediaHoundLogo.hidden = YES;
        self.mediaHoundTitle.hidden = YES;
        self.searchLiteLabel.hidden = YES;
    }
    else {
        self.mediaHoundLogo.hidden = NO;
        self.mediaHoundTitle.hidden = NO;
        self.searchLiteLabel.hidden = NO;
    }
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UITableView Management

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (!self.additionalSearchPages) {
        return self.allSearchResults.count;
    }
    else {
        return self.allSearchResults.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* lastCellIdentifier = @"Load_More_Cell";
    static NSString* searchResultCellIdentifier = @"Main_Search_Cell";
    
    NSInteger lastCellRow = self.allSearchResults.count;
    
    
    if (self.additionalSearchPages && indexPath.row == lastCellRow) {
        UITableViewCell* loadMoreCell = [tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];
        return loadMoreCell;
    }
    else {
        MHLSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellIdentifier];
        
        /*
         The search results contains a series of MHRelationalPairs.
         */
        MHRelationalPair* pair = self.allSearchResults[indexPath.row];
        MHObject* result = pair.object;
        
        /*
         The result object has a name property that we can display to the user.
         */
        cell.searchNameLabel.text = result.metadata.name;
        
        /*
         Each search result has a primary image associated with it
         */
        cell.searchImageView.image = nil; // Clear out the searchedImg right away
        [result fetchPrimaryImage].thenInBackground(^(MHImage* primaryImage) {
            /*
             The MHImage contains an image URL decided on by MediaHound to best
             represent a particular object.
             There are different resolutions available: thumbnail, small, medium, large, original.
             */
            NSURL* url = [NSURL URLWithString:primaryImage.metadata.large.url];
            NSData* data = [NSData dataWithContentsOfURL:url];
            UIImage* img = [UIImage imageWithData:data];
            return img;
        }).then(^(UIImage* image) {
            /*
             We are now back on the Main thread.
             We need to make sure this UITableViewCell has not been recycled and used by a different row.
             */
            if ([cell.searchNameLabel.text isEqualToString:result.metadata.name]) {
                cell.searchImageView.image = image;
            }
        });
        
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:0.4];
        [cell setSelectedBackgroundView:bgColorView];
        
        return cell;
    }
}

#pragma mark - TableView Management

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastCellRow = self.allSearchResults.count;

    if (self.additionalSearchPages && indexPath.row == lastCellRow) {
        /*
         Since the Search results come back as paged reponses, use the fetchNext method (PMKPromise*) to retreive
         the next set of results from the user's search. You will receive another set of results that contain a 
         'content' property of type MHObject, as well as a BOOL (hasMorePages) indicating additional pages.
         */
        [self.response fetchNext].then(^(MHPagedResponse* nextPagedResponse) {
            self.response = nextPagedResponse;
            self.additionalSearchPages = nextPagedResponse.hasMorePages;
            [self.allSearchResults addObjectsFromArray:nextPagedResponse.content];
            [tableView reloadData];
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MHLResultViewController* resultController = [segue destinationViewController];
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    MHRelationalPair* pair = self.allSearchResults[indexPath.row];
    MHObject* result = pair.object;
    
    resultController.result = result;
}

#pragma mark - UISearchBar Behaviors

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchBar.text isEqualToString:@""]) {
        self.allSearchResults = [NSMutableArray array];
        self.additionalSearchPages = NO;
        [self.tableView reloadData];
    }
    else {
        /*
         Use the MHSearch class to perform search queries on The Entertainment Graph.
         When the results return, they will come back in pages.
         Search Scopes allow you to filter what type of content you want to search for.
         In this case we are searching across all types.
         */
        [MHSearch fetchResultsForSearchTerm:searchText scope:MHSearchScopeAll].then(^(MHPagedResponse* pagedSearchResult) {
            
            /*
             First make sure that the user hasn't changed the search text since we started the search request.
             */
            if ([self.searchBar.text isEqualToString:searchText]) {
                NSMutableArray* searchResultContent = pagedSearchResult.content.mutableCopy;
                self.response = pagedSearchResult;
                self.allSearchResults = searchResultContent;
                [self.tableView reloadData];
                
                /*
                 An MHPagedSearchResponse will indicate if there are additional paged responses that can 
                 still be fetched.
                 */
                if (pagedSearchResult.hasMorePages) {
                    self.additionalSearchPages = YES;
                };
            }
        });
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
