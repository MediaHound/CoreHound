//
//  MH_CH_SearchCell
//  CoreHound
//
//  Created by Dustin Mote on 3/9/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MH_CH_SearchCell : UITableViewCell <UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *searchedImg;
@property (weak, nonatomic) IBOutlet UILabel *searchedName;


@end