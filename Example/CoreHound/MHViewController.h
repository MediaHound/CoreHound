//
//  MHViewController.h
//  CoreHound
//
//  Created by Dustin Bachrach on 03/02/2015.
//  Copyright (c) 2014 Dustin Bachrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar* MHSDKSearch;

@property (weak, nonatomic) IBOutlet UIImageView *mediaHoundLogo;

@property (weak, nonatomic) IBOutlet UIImageView *mediaHoundTitle;

@property (weak, nonatomic) IBOutlet UILabel *searchLiteLabel;

@end
