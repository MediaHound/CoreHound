//
//  MHidViewController.h
//  CoreHound
//
//  Created by Dustin Mote on 3/17/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreHound/MHApi.h>
#import "MH_CH_CustomCell.h"

@interface MHidViewController : UITableViewController


@property (nonatomic) MHPagedSearchResponse* currentMHid;
@property (nonatomic) NSArray* searchIDResult;
@property (nonatomic) UIImage* mhPrimaryImg;
@property (nonatomic) NSString* mhName;

@end
