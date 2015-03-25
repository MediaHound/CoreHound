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


@end

#pragma mark



@implementation MHViewController



#pragma mark - UIApplication events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    
//     UIViewController *root = self.navigationController.viewControllers[0];
  
    self.searchBar.placeholder = @"Search the Graph";
    self.additionalSearchPages = NO;

    
    if ([[UIScreen mainScreen]bounds].size.height <= 498) {
        
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
    
    NSString* lastCellIdentifier = @"Load_More_Cell";
    NSString* searchCellIdentifier = @"Main_Search_Cell";
    
    short int lastCellRow = self.allSearchResults.count;
    
    
    if (self.additionalSearchPages && indexPath.row == lastCellRow)
    {
        UITableViewCell* loadCell = [tableView dequeueReusableCellWithIdentifier: lastCellIdentifier];
        
        return loadCell;
        
        
    } else {
        
        /*
         
         The API contains an AutoCompleteResults class. Use this class to handle your returned results.
         
         */
        
        MH_CH_SearchCell* cell = [self.TableView dequeueReusableCellWithIdentifier: searchCellIdentifier];
        
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
             
             
             Since the Search results come back as paged reponses use the fetchNext method to retreive the next set of results from the search. You will receive another array of AutoCompleteResults.
           
             
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
         
         Use the PromiseKit built into MHSearch to take in the entered text across all scopes.
         When the  results return, they will come in Paged in sets of 12 (result page set number could change in the future).

         
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
 
       // TODO: crete separate function to hamdle whitespaces
    
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
