//
//  MH_CH_ContributorCell.h
//  CoreHound
//
//  Created by Dustin Mote on 3/18/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHLContributorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contributorImageView;
@property (weak, nonatomic) IBOutlet UILabel *contributorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributorRoleLabel;

@end
