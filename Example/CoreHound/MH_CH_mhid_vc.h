//
//  MH_CH_mhid_vc.h
//  CoreHound
//
//  Created by Dustin Mote on 3/18/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreHound/MHApi.h>

@interface MH_CH_mhid_vc : UIViewController  <UITableViewDataSource, UITableViewDelegate>



@property (nonatomic) NSString* currentMHid;
@property (nonatomic) NSArray* searchIDResult;
@property (nonatomic) NSURL* mhPrimaryImg;
@property (nonatomic) NSString* mhName;
@property (nonatomic) NSArray* mhContributorNames;
@property (nonatomic) NSArray* mhContentImages;
@property (nonatomic) NSString* mhIDName;


@end
