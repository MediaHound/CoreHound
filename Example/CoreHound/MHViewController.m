//
//  MHViewController.m
//  CoreHound
//
//  Created by Dustin Bachrach on 03/02/2015.
//  Copyright (c) 2014 Dustin Bachrach. All rights reserved.
//

#import "MHViewController.h"
#import <CoreHound/MHApi.h>
#import "MH_CH_Cells.h"
#import "MH_CH_mhid_vc.h"


@interface MHViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) MHPagedSearchResponse* response;
@property (strong, nonatomic) NSMutableArray* allSearchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL additionalSearchPages;
@property (readonly, nonatomic) UIViewController* root;

@end

#pragma mark



@implementation MHViewController



#pragma mark - UIApplication events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.searchBar.placeholder = @"Search the Graph";
    self.additionalSearchPages = NO;

    if ([[UIScreen mainScreen]bounds].size.height <= 500) {
        
        self.title = @"MediaHound";
        self.mediaHoundLogo.hidden = YES;
        self.mediaHoundTitle.hidden = YES;
        self.searchLiteLabel.hidden = YES;
        
    } else {
        
        self.title = @"MediaHound Search Lite";
        self.mediaHoundLogo.hidden = NO;
        self.mediaHoundTitle.hidden = NO;
        self.searchLiteLabel.hidden = NO;
        
        
    }
    
    [self.searchBar becomeFirstResponder];
    
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
    
    if (!self.additionalSearchPages) {
        
        return self.allSearchResults.count;
        
    } else {
        
        return self.allSearchResults.count + 1;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* lastCell = @"Load_More_Cell";
    NSString* searchResultCell = @"Main_Search_Cell";
    
    short int lastCellRow = self.allSearchResults.count;
    
    
    if (self.additionalSearchPages && indexPath.row == lastCellRow)
    {
        UITableViewCell* load_More_Cell = [tableView dequeueReusableCellWithIdentifier: lastCell];
        
        return load_More_Cell;
        
        
    } else {
        
        MH_CH_SearchCell* cell = [self.TableView dequeueReusableCellWithIdentifier: searchResultCell];
        
        
        /*
         
         
         The API contains an AutoCompleteResults class. Use this class to handle your returned results.
         
         */
        
        AutocompleteResult* result = self.allSearchResults[indexPath.row];
        
        
        
        
        /*
         
         The initial results returned will contain a single URL for the primary image.
         
         */
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            /*
             
             
                The Primary Image URL property (NSURL*) contains an image decided on by MediaHound to best represent a particular mhid.
             
             
                */
            
            
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
        

        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [cell setSelectedBackgroundView:bgColorView];
        
        
        return cell;
        
    }
    
}




#pragma mark - Navigation




- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        short int lastCellRow = self.allSearchResults.count;
    
        if (indexPath.row == lastCellRow) {

            /*
             
             
             Since the Search results come back as paged reponses use the fetchNext method (PMKPromise*) to retreive the next set of results from the user's search. You will receive another JSON of results that contain a 'content' property of type autoCompleteSearchResults, as well as a BOOL (hasMorePages) indicating additional pages.
           
             
             */
            
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
    
    
    MH_CH_mhid_vc* mhidVC = [segue destinationViewController];
    NSIndexPath* path =  [self.TableView indexPathForSelectedRow];
    AutocompleteResult* responsePath = self.allSearchResults[path.row];

    /*
     
     One of the primary reasons for searching is to discover a particular mhid. The AutoCompleteResult class will deliver the mhid that can then be fetched independently as seen in the MediaHound-CoreHound-mhid-ViewController (MH_CH_mhid_vc). Searching for result is a separate process then directly getting information from the entertainment graph. Queries into the graph are accomplished through specific mhid's.
     
     TODO: verify that the assertion is correct
     
     */
     
    [mhidVC setCurrentMHid  :responsePath.mhid];
    [mhidVC setMhName       :responsePath.name];
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
         
         Use the PromiseKit built into MHSearch to take in the entered text across all scopes. When the results return, they will come back as Paged in sets of 12 results per page (NOTE: results set number could change in the future). Search results are a different return type than fetching directly from the graph as seen in the MediaHound-CoreHound-mhid-ViewController (MH_CH_mhid_vc). Use particular scopes, if desired, to restrict results:
  
         
         * Do not filter by content type. Return all results.
         
        MHSearchScopeAll,
        
       
         * Only return Movie results.
       
        MHSearchScopeMovie,
        
      
         * Only return Song results.
      
        MHSearchScopeSong,
        
     
         * Only return Album results.
     
        MHSearchScopeAlbum,
        
    
         * Only return TV Series results.
    
        MHSearchScopeTvSeries,
        
   
         * Only return TV Season results.
   
        MHSearchScopeTvSeason,
        
  
         * Only return TV Episode results.
  
        MHSearchScopeTvEpisode,
        
  
         * Only return Book results.
  
        MHSearchScopeBook,
        
  
         * Only return Game results.
  
        MHSearchScopeGame,
        
  
         * Only return Collection results.
  
        MHSearchScopeCollection,
        
  
         * Only return User results.
  
        MHSearchScopeUser,
        
  
         * Only return Contributor results.
  
        MHSearchScopeContributor
*/
        
        [MHSearch fetchResultsForSearchTerm:searchText scope:MHSearchScopeAll].then(^(MHPagedSearchResponse* pagedSearchResult) {
            
            
            if ([self.searchBar.text isEqualToString:searchText]) {
                NSArray* searchResultContent = pagedSearchResult.content;
                self.response = pagedSearchResult;
                self.allSearchResults = searchResultContent.mutableCopy;
                [self.TableView reloadData];
                
                /*
                 
                    An MHPagedSearchResponse will indicate if there are additional paged responses that still need to be fetched.
                 
                    */
                if ([pagedSearchResult hasMorePages] == YES) {
                    
                    self.additionalSearchPages = YES;
                    
                };
                
            }
        });
        
    }
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [self.TableView reloadData];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    // TODO: how to handle additional search results pages not showing properly, ex- Search for 'Congeniality' and delete entry and search for 'Troy'
    //    self.additionalSearchPages = NO;
    //    [self.TableView reloadData];
    
    
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
    
    [self.allSearchResults arrayByAddingObjectsFromArray:self.allSearchResults];
    [self.TableView reloadData];
    [self.searchBar resignFirstResponder];
    
}




#pragma mark - Edge use cases

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}


@end
