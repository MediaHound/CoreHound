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
@property (strong, nonatomic) NSMutableArray* mediaMhidPrep;
@property (strong, nonatomic) NSMutableArray* mediaNamePrep;
@property (strong, nonatomic) NSMutableArray* mediaContributorsName;
@property (strong, nonatomic) NSMutableArray* mediaContributorsRole;
@property (strong, nonatomic) NSMutableArray* mediaContributorsImageURLs;


@end


@implementation MH_CH_mhid_vc


#pragma mark - View Controller Events

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.mhName;
    
    
    self.navigationController.navigationBar.hidden = NO;
    
    if (self.navigationController.viewControllers.count >= 24) {
        self.mhidTableView.userInteractionEnabled = NO;
    }
    
    
    self.mediaContributorsName = [[NSMutableArray alloc]init];
    self.mediaContributorsRole = [[NSMutableArray alloc]init];
    self.mediaContributorsImageURLs = [[NSMutableArray alloc]init];
    self.mediaMhidPrep = [[NSMutableArray alloc]init];
    self.mediaNamePrep = [[NSMutableArray alloc]init];
    
    
    

    [MHLoginSession loginWithUsername:@"db" password:@"p"].then(^() {
        PMKPromise* promise = [MHObject fetchByMhid:self.currentMHid];
        
        promise.then(^(MHObject* obj){
            
           
            
            return [obj fetchPrimaryImage];
            
        }).thenInBackground(^(MHImage* primaryImage) {
            
            NSString* url = primaryImage.original.url;
            // Download image at `url`.
            NSURL* fetchedUrl = [[NSURL alloc]initWithString:url];
            
            NSData* data= [NSData dataWithContentsOfURL:fetchedUrl];
            
            UIImage* img = [UIImage imageWithData:data];
            
            self.primaryImage = img;
            

        }).then(^{
            
            [self.mhidTableView reloadData];
            
        });
        
        
            promise.then(^(MHMedia* obj){
                
                if ([obj isKindOfClass:MHContributor.class]) {
                    
                    return [(MHContributor*)obj fetchMedia];
                    
                } else {
                    
                    return [obj fetchContributors];
                    
                }
                
                
            }).then(^(MHPagedResponse* response){
                
                NSMutableArray* promiseArray = [NSMutableArray array];
                
                NSInteger i = 0;
                for (MHRelationalPair* pair in response.content){
                    
                    MHObject* obj = pair.object;
                    MHMetadata* meta = obj.metadata;
                    NSString* mhid = meta.mhid;
                    NSString* name = meta.name;
                    
                    [self.mediaContributorsName addObject:name];
                    [self.mediaContributorsImageURLs addObject:[NSNull null]];
                    
                    [self.mediaNamePrep addObject:name];
                    [self.mediaMhidPrep addObject:mhid];
                    
                    
                    MHContext* ctxt = pair.context;
                    NSArray* relationships = ctxt.relationships;
                    NSDictionary* contr = relationships.lastObject;
                    NSString* contribution = [contr valueForKey:@"contribution"];
                    
                    if (contribution) {
                        [self.mediaContributorsRole addObject:contribution];
                    }
                    else {
                        [self.mediaContributorsRole addObject:[NSNull null]];
                    }
                    
                    
                    
                    PMKPromise* p = [obj fetchPrimaryImage].then(^(MHImage* metaImg) {
                    
                        
                        MHImageData* metaImgOrig = metaImg.original;
                        NSString* metaImgURL = metaImgOrig.url;
                        self.mediaContributorsImageURLs[i] = metaImgURL;
                        
                    });
                    
                    
                    // Adding to the array for when the promise of fetching the image data set info finishes
                    [promiseArray addObject:p];
                    
                    i++;
                }
                
                
                [PMKPromise when:promiseArray].then(^{
                    [self.mhidTableView reloadData];
                });
                
                
            });
        

    });

}


- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 380.0f;
        
    } else {
        
        return 64.0f;
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    MH_CH_mhid_vc* mhidVC = [segue destinationViewController];
    NSIndexPath* path =  [self.mhidTableView indexPathForSelectedRow];
  
    [mhidVC setCurrentMHid  :self.mediaMhidPrep[path.row - 1]];
    [mhidVC setMhName       :self.mediaNamePrep[path.row - 1]];

}


-(void)didReceiveMemoryWarning {
    
    self.mhidTableView.userInteractionEnabled = NO;
    
}

#pragma mark - Table View Management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
 
    return self.mediaContributorsName.count + 1;
    

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
        
    } else {
        
        MH_CH_ContributorCell* contributorCell = [tableView dequeueReusableCellWithIdentifier:@"Contributor_Cell" forIndexPath:indexPath];
        
   
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                
                NSURL* url = [NSURL URLWithString:self.mediaContributorsImageURLs[indexPath.row - 1]];
                
                NSData* data= [NSData dataWithContentsOfURL:url];
                
                UIImage* img = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([contributorCell.mhid_Contributor_Name.text isEqualToString:self.mediaContributorsName[indexPath.row - 1]]) {
                        
                        contributorCell.mhid_Contributor_Image.image = img;
                     
                    }
                    
                });
                
            });
        
        
        NSString* contrName = self.mediaContributorsName[indexPath.row - 1];
        if ([contrName isEqual:[NSNull null]]) {
            contrName = @" ";
        }
        contributorCell.mhid_Contributor_Name.text = contrName;
        
        NSString* contrRole = self.mediaContributorsRole[indexPath.row - 1];
        if ([contrRole isEqual:[NSNull null]]) {
            contrRole = @" ";
        }
        contributorCell.mhid_Contributor_Role.text = contrRole;
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [contributorCell setSelectedBackgroundView:bgColorView];
        
        return contributorCell;
        
    }
    
    
}

#pragma mark - Navigation




- (IBAction)searchBarButtonPressed:(UIBarButtonItem *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES]; 
 
    
    
}



@end
