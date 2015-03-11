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


@interface MHViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) NSArray* searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MHViewController


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    
    
    /* 
     
     Use the PromiseKit built into MHSearch to take in the entered text across all scopes. 
     When the  results return, they will come in Paged in sets of 12.
     
     */
    
    [MHSearch fetchResultsForSearchTerm:searchText scope:MHSearchScopeAll].then(^(MHPagedSearchResponse* response) {
        
        
        if ([self.searchBar.text isEqualToString:searchText]) {
            NSArray* content = response.content;
            self.searchResults = content;
            [self.TableView reloadData];
        }
    });
    
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /* 
     
     The API contains an AutoCompleteResults class. Use this class to handle your returned results.
    
     */
     
     MH_CH_CustomCell* cell = [self.TableView dequeueReusableCellWithIdentifier:@"Main_Search_Cell"];
    
        AutocompleteResult* result = self.searchResults[indexPath.row];
    
    
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
    
    return cell;
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar.placeholder = @"Search the Graph";


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
