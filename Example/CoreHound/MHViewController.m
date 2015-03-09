//
//  MHViewController.m
//  CoreHound
//
//  Created by Dustin Bachrach on 03/02/2015.
//  Copyright (c) 2014 Dustin Bachrach. All rights reserved.
//

#import "MHViewController.h"
#import <CoreHound/MHApi.h>


@interface MHViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) NSArray* searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MHViewController


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    
    
    // Fetching results for terms typed in to the search bar with an all scope
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
    
    UITableViewCell* cell = [self.TableView dequeueReusableCellWithIdentifier:@"Main_Search_Cell"];
        AutocompleteResult* result = self.searchResults[indexPath.row];
    
    cell.textLabel.text = result.name;
    
    return cell;
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
