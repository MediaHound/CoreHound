//
//  MHidViewController.m
//  CoreHound
//
//  Created by Dustin Mote on 3/17/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

#import "MHidViewController.h"
#import <CoreHound/MHApi.h>
#import "MH_CH_CustomCell.h"

@implementation MHidViewController





#pragma mark - UIApplication events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.searchIDResult = _currentMHid.content;
    self.mhName = self.searchIDResult[3];
    self.mhPrimaryImg = self.searchIDResult[2];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MHid_Cell" forIndexPath: indexPath];
    
    
//    cell.textLabel.text = self.mhName[indexPath.row];
    
    return cell;
    
    
}


@end
