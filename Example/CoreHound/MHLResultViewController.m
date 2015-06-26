//
//  MHLResultViewController.m
//  CoreHound
//
//  Created by Dustin Mote on 3/18/15.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

#import "MHLResultViewController.h"
#import "MHLCells.h"


@interface MHLResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImage* primaryImage;
@property (strong, nonatomic) NSArray* contributors;

@end


@implementation MHLResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.result.metadata.name;
    
    /*
     Max navigation depth of 24.
     */
    if (self.navigationController.viewControllers.count >= 24) {
        self.tableView.userInteractionEnabled = NO;
    }
    
    PMKPromise* promise = nil;
    if ([self.result isKindOfClass:MHMedia.class]) {
        /*
         If this page is Media, then we fetch the contributors to the media.
         */
        promise = [(MHMedia*)self.result fetchContributors];
    }
    else {
        /*
         If this page is a Contributor, then we fetch the media they have contributed to.
         */
        promise = [(MHContributor*)self.result fetchMedia];
    }
    
    promise.then(^(MHPagedResponse* response){
        /*
         When the contributors/media load, we reload the table.
         */
        self.contributors = response.content;
        [self.tableView reloadData];
    });
    
    
    /*
     The primary image property may be unrealized. You should not access it directly.
     You need to call (fetchPrimaryImage) to ensure it has been loaded.
     */
    [self.result fetchPrimaryImage].thenInBackground(^(MHImage* primaryImage) {
        NSURL* url = [NSURL URLWithString:primaryImage.metadata.large.url];
        NSData* data= [NSData dataWithContentsOfURL:url];
        UIImage* img = [UIImage imageWithData:data];
        
        self.primaryImage = img;
    }).then(^{
        /*
         We are back on the Main Thread.
         */
        [self.tableView reloadData];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 380.0f;
    }
    else {
        return 64.0f;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MHLResultViewController* resultController = [segue destinationViewController];
    NSIndexPath* path = [self.tableView indexPathForSelectedRow];
  
    MHRelationalPair* pair = self.contributors[path.row - 1];
    MHObject* result = pair.object;
    resultController.result = result;
}

#pragma mark - Table View Management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contributors.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* primaryCellIdentifier = @"Primary_Image_Cell";
    static NSString* contributorCellIdentifier = @"Contributor_Cell";
    
    if (indexPath.row == 0) {
        MHLPrimaryImageCell* mainImageCell = [tableView dequeueReusableCellWithIdentifier:primaryCellIdentifier
                                                                             forIndexPath:indexPath];
        
        mainImageCell.primaryImageView.image = self.primaryImage;
        
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [mainImageCell setSelectedBackgroundView:bgColorView];
        
        return mainImageCell;
    }
    else {
        MHLContributorCell* contributorCell = [tableView dequeueReusableCellWithIdentifier:contributorCellIdentifier
                                                                              forIndexPath:indexPath];
        
        MHRelationalPair* pair = self.contributors[indexPath.row - 1];
        MHObject* contributor = pair.object;
        MHContext* context = pair.context;
        
        contributorCell.contributorNameLabel.text = contributor.metadata.name;
        
        MHRelationship* relationship = context.relationships.firstObject;
        NSString* contribution = relationship.contribution;
        
        if (contribution) {
            contributorCell.contributorRoleLabel.text = contribution;
        }
        else {
            contributorCell.contributorRoleLabel.text = @" ";
        }
        
        
        contributorCell.contributorImageView.image = nil;
        [contributor fetchPrimaryImage].thenInBackground(^(MHImage* primaryImage) {
            /*
             The MHImage contains an image URL decided on by MediaHound to best
             represent a particular object.
             There are different resolutions available: thumbnail, small, medium, large, original.
             */
            NSURL* url = [NSURL URLWithString:primaryImage.metadata.large.url];
            NSData* data = [NSData dataWithContentsOfURL:url];
            UIImage* img = [UIImage imageWithData:data];
            return img;
        }).then(^(UIImage* image) {
            /*
             We are now back on the Main thread.
             We need to make sure this UITableViewCell has not been recycled and used by a different row.
             */
            if ([contributorCell.contributorNameLabel.text isEqualToString:contributor.metadata.name]) {
                contributorCell.contributorImageView.image = image;
            }
        });

        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [contributorCell setSelectedBackgroundView:bgColorView];
        
        return contributorCell;
    }
}

#pragma mark - Navigation

- (IBAction)searchBarButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
