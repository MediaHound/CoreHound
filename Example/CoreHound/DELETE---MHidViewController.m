//
//  MHidViewController.m
//  CoreHound
//
//  Created by Dustin Mote on 3/17/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//


#import "DELETE---MHidViewController.h"
#import <CoreHound/MHApi.h>
#import "MH_CH_SearchCell.h"

@implementation MHidViewController
//
//
//
//
//
//#pragma mark - UIApplication events
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    
//    self.mhName =  _currentMHid;
////    NSURL* mhIDImgURL = [[NSURL alloc]init];
//    
//
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
//#pragma mark - Table View Management
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    // I know this is not right
//    return self.currentMHid.length;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    MH_CH_SearchCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MHid_cell" forIndexPath:indexPath];
//    
//    
//
//    
//    if (indexPath.row == 0) {
//     
//        cell.searchedName.text = self.mhName;
//      
//   
//        
//    } else if (indexPath.row == 1 ) {
//       
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSData* data = [NSData dataWithContentsOfURL:self.mhPrimaryImg];
//            
//            UIImage* img = [UIImage imageWithData:data];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                cell.searchedImg.image = img;
//                
//            });
//            
//         });
//        
//    
//    } else if (indexPath.row >= 1 ) {
//            
//            cell.searchedName.text = @"other info";
//            cell.searchedImg.image = nil;
//    
//            
//    }
//    
//    UIView *bgColorView = [[UIView alloc] init];
//    bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
//    [cell setSelectedBackgroundView:bgColorView];
//        
//    return cell;
//    
//    
//}
//
//
//
//
//
@end
