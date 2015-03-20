//
//  MH_CH_mhid_vc.m
//  CoreHound
//
//  Created by Dustin Mote on 3/18/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

#import "MH_CH_mhid_vc.h"
#import "MH_CH_Cells.h"


@interface MH_CH_mhid_vc () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIImage* primaryImage;
@property (strong, nonatomic) NSArray* returnedContent;
@property (weak, nonatomic) NSArray* returnedContentFirst;
@property (weak, nonatomic) NSArray* returnedContentLast;
@property (weak, nonatomic) NSArray* returnedContentSoloName;

@end


@implementation MH_CH_mhid_vc 
#pragma mark - View Controller Events


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.mhName;
    self.navigationController.navigationBar.hidden = NO;
  

    [MHLoginSession loginWithUsername:@"db" password:@"p"].then(^() {
        PMKPromise* promise = [MHObject fetchByMhid:self.currentMHid];
        
        promise.then(^(MHObject* obj){
            
//            self.returnedContent = obj.metadata;
            return [obj fetchPrimaryImage];
            
        }).thenInBackground(^(MHImage* primaryImage) {
            
            NSString* url = primaryImage.original.url;
            // Download image at `url`.
            NSURL* fetchedUrl = [[NSURL alloc]initWithString:url];
            
            NSData* data= [NSData dataWithContentsOfURL:fetchedUrl];
            
            UIImage* img = [UIImage imageWithData:data];
            
            self.primaryImage = img;
            

        }).finally(^{
            
            [self.mhidTableView reloadData];
            
        });
        
        promise.then(^(MHMedia* obj){
            
            return [obj fetchKeyContributors];
            
        }).then(^(NSArray* contributor){
            
            self.returnedContent = contributor;
            self.returnedContentFirst = contributor.firstObject;
            self.returnedContentLast = contributor.lastObject;

            NSLog(@" First return %@", self.returnedContent.description);
            NSLog(@" Second Return %@", self.returnedContentFirst.description);
            NSLog(@" Third Return %@", self.returnedContentLast.description);
            
            
//            self.mhContributorNames = self.returnedContent.;
            
            [self.mhidTableView reloadData];
            
        });
        
        
    });





}


- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 380.0f;
        
    } else {
        
        return 64.0f;
    }
    
}


#pragma mark - Table View Management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
 
    return self.returnedContent.count + 1;
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        MH_CH_PrimaryImgCell* mainImageCell = [tableView dequeueReusableCellWithIdentifier:@"Primary_Image_Cell"];
        
        mainImageCell.mhid_Primary_Image.image = self.primaryImage;
        
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [mainImageCell setSelectedBackgroundView:bgColorView];
        
        return mainImageCell;
        
    } else if (indexPath.row > 0) {
        
        MH_CH_ContributorCell* contributorCell = [tableView dequeueReusableCellWithIdentifier:@"Contributor_Cell" forIndexPath:indexPath];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData* data= [NSData dataWithContentsOfURL:self.mhPrimaryImg];
            
            UIImage* img = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                // TODO: how to handle the array of promis returns of the individual MHID
                contributorCell.mhid_Contributor_Image.image = img;
                
            });
            
            
        });
        
        
        contributorCell.mhid_Contributor_Name.text = self.returnedContentFirst.description;
        contributorCell.mhid_Contributor_Role.text = self.returnedContentLast.description;
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [contributorCell setSelectedBackgroundView:bgColorView];
        
        return contributorCell;
        
    } else {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        // Return an empty green cell indidcating an error occured
        
        return cell;
        
    }
    
    
}

@end
