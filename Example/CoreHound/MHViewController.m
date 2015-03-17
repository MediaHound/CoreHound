//
//  MHViewController.m
//  CoreHound
//
//  Created by Dustin Bachrach on 03/02/2015.
//  Copyright (c) 2014 Dustin Bachrach. All rights reserved.
//

#import "MHViewController.h"
#import <CoreHound/MHApi.h>
#import "MH_CH_CustomCell.h"
#import "MHidViewController.h"


@interface MHViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) MHPagedSearchResponse* response;
@property (strong, nonatomic) NSMutableArray* allSearchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL additionalSearchPages;


@end

#pragma mark



@implementation MHViewController



#pragma mark - UIApplication events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar.placeholder = @"Search the Graph";
    self.additionalSearchPages = NO;

    [_searchBar becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView Management

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    if (self.additionalSearchPages == NO) {
        
        return self.allSearchResults.count;
        
    } else {
        
        return self.allSearchResults.count + 1;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* lastCellIdentifier = @"Load_More_Cell";
    NSString* searchCellIdentifier = @"Main_Search_Cell";
    UIView *bgColorView = [[UIView alloc] init];
    
    short int lastCellRow = self.allSearchResults.count;
    
    
    if (self.additionalSearchPages && indexPath.row == lastCellRow)
    {
        UITableViewCell* loadCell = [tableView dequeueReusableCellWithIdentifier: lastCellIdentifier];
        
        return loadCell;
        
        
    } else {
        
        /*
         
         The API contains an AutoCompleteResults class. Use this class to handle your returned results.
         
         */
        
        MH_CH_CustomCell* cell = [self.TableView dequeueReusableCellWithIdentifier: searchCellIdentifier];
        
        AutocompleteResult* result = self.allSearchResults[indexPath.row];
        
        
        /*
         
         The initial results returned will contain a URL for the primary images.
         
         */
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            NSData* data= [NSData dataWithContentsOfURL:result.primaryImageUrl];
            
            UIImage* img = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([cell.searchedName.text isEqualToString:result.name]) {
                    
                    cell.searchedImg.image = img;
                }
            });
            
        });
        
        cell.searchedName.text = result.name;
        cell.searchedImg.image = nil;
        
//        
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [cell setSelectedBackgroundView:bgColorView];
        
        
        return cell;
        
    }
    
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        short int lastCellRow = self.allSearchResults.count;
    
        if (indexPath.row == lastCellRow) {
            
            [self.response fetchNext].then(^(MHPagedSearchResponse* responded) {

                self.response = responded;
                self.additionalSearchPages = YES;
                [self.allSearchResults addObjectsFromArray:responded.content];
                [self.TableView reloadData];
                
            });
            
        }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    
    MHidViewController* mhidVC = [segue destinationViewController];
    NSIndexPath* path =  [self.TableView indexPathsForSelectedRows];
    MHPagedSearchResponse* responsePath = _response.content[path.row];
    [mhidVC setCurrentMHid:responsePath];
    
    
}


#pragma mark - UISearchBar Behaviors
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    
    if ([self.searchBar.text isEqualToString:@""]) {
        
        self.allSearchResults = [NSMutableArray array];
        self.additionalSearchPages = NO;
        [self.TableView reloadData];
        
    } else {
        
        /*
         
         Use the PromiseKit built into MHSearch to take in the entered text across all scopes.
         When the  results return, they will come in Paged in sets of 12.
         
         */
        
        [MHSearch fetchResultsForSearchTerm:searchText scope:MHSearchScopeAll].then(^(MHPagedSearchResponse* response) {
            
            
            if ([self.searchBar.text isEqualToString:searchText]) {
                NSArray* content = response.content;
                self.response = response;
                self.allSearchResults = content.mutableCopy;
                [self.TableView reloadData];
                
                if ([response hasMorePages] == YES) {
                    
                    self.additionalSearchPages = YES;
                    
                };
                
            }
        });
        
    }
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    self.additionalSearchPages = NO;
    [self.TableView reloadData];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    if ([self.searchBar.text isEqual: @""]) {
        
        [self.TableView reloadData];
        
    } else {
        
        if ([self.searchBar.text isEqual: @" "]) {
            
            [self.TableView reloadData];
            
        }
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self.allSearchResults arrayByAddingObjectsFromArray:_allSearchResults];
    [self.TableView reloadData];
    [_searchBar resignFirstResponder];
    
}




#pragma mark - Edge use cases

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}




@end
