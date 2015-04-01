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

@property BOOL isMedia;






@end


@implementation MH_CH_mhid_vc



#pragma mark - View Controller Events

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.mhName;
    
    if (self.navigationController.viewControllers.count >= 24) {
        self.mhidTableView.userInteractionEnabled = NO;
    }
    
    self.mediaContributorsName      = [[NSMutableArray alloc]init];
    self.mediaContributorsRole      = [[NSMutableArray alloc]init];
    self.mediaContributorsImageURLs = [[NSMutableArray alloc]init];
    self.mediaMhidPrep              = [[NSMutableArray alloc]init];
    self.mediaNamePrep              = [[NSMutableArray alloc]init];
    
    
    
    self.isMedia = NO;
    
    
    /*
     
     
     The PromiseKit pod is one if the dependencies of CoreHound. Use promises to request the MHObjects from the entertainment graph. Once the mhid is acquired from the search, then use the 'fetchByMhid' method to get the specific MHObject. MHObjects are cached, so a request for an already fetched mhid will not require a network request. See Documentation for for the properties via JSON for an MHObject.
     
     
     */
    
// TODO: handle login session scenarios, we don't want to distribute with login credentials present
    
    [[MHSDK sharedSDK] configureWithClientId:@"mhclt_MHLite"
                                clientSecret:@"1YIdQRqKtvQMmt3t0qZwVc1Tg2dDRheCLjhvODxloO686whQ"].then(^() {
        PMKPromise* promise = [MHObject fetchByMhid:self.currentMHid];
        
        promise.then(^(MHObject* obj){
            
         /**
             * The primary image property may be unrealized. You should not access it directly.
             * You need to call (fetchPrimaryImage) to ensure it has been loaded.
             * This property is KVO compliant.
             */
            return [obj fetchPrimaryImage];
            
            /*
             
                Update UI elements on the main thread. Use (.thenInBackground) method or a dispatch queue to forcibly download the data on a background thread.
             
                */
            
            
        }).thenInBackground(^(MHImage* primaryImage) {
            
            NSString* url = primaryImage.original.url;
            NSURL* fetchedUrl = [[NSURL alloc]initWithString:url];
            NSData* data= [NSData dataWithContentsOfURL:fetchedUrl];
            UIImage* img = [UIImage imageWithData:data];
            
            self.primaryImage = img;
        
            
            /*
             
                Use a standard (.then) method to run the block back on the main thread.
             
                */
        
        }).then(^{
            
            [self.mhidTableView reloadData];
            
        });
        
        
            promise.then(^(MHMedia* obj){
                
                if ([obj isKindOfClass:MHContributor.class]) {
                    
                    self.isMedia = YES;
                    return [(MHContributor*)obj fetchMedia];
                    
                } else {
                    
                    self.isMedia = NO;
                    return [obj fetchContributors];
                    
                }
                
                
            }).then(^(MHPagedResponse* response){
                
                NSMutableArray* promiseArray = [NSMutableArray array];
                
                /*
                 
                     The paged response that returns from fetching from the entertainment graph contains sets of Relational pairs. In this example the response is looped through to extract individual properties which are then added to arrays declared in the header. The arrays are being used for the index of the Table View Data Source. Since it is possible for the parameter to comback as nil, a null object gets added in its place.
                 
                     Each relational pair contains an object and a context.
                 
                     */
                
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
                    
                    
                    
                    /*
                     
                            Fetching the primary image inside of a promise is preferred instead of accessing the URL directly in the parsing of the content. This is due to variances in image sizes and network conditions.
                     
                         */
                    
                    PMKPromise* p = [obj fetchPrimaryImage].then(^(MHImage* metaImg) {
                    
                        
                        MHImageData* metaImgOrig = metaImg.original;
                        NSString* metaImgURL = metaImgOrig.url;
                        self.mediaContributorsImageURLs[i] = metaImgURL;
                        
                    });
                    
                    
                    /*
                            
                            The promise then gets added to an array of promises for when the fetching the image data finishes to ensure that the reloading of table data has complete and ordered information.
                    
                          */
                    
                    [promiseArray addObject:p];
                    
                    i++;
                }
                
                
                /*
                 
                     You can use a 'Promise when:' to hold off on running the next block until after all of the data has been collected.
                 
                     */
                
                [PMKPromise when:promiseArray].then(^{
                    
                [self.mhidTableView reloadData];
                    
                });
                
                
            });
        

    });

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

 // TODO: decide to keep or loose animation
- (CABasicAnimation*)cellImageAnimation
{
    CABasicAnimation* cellAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    cellAnimation.duration = 0.05;
    cellAnimation.toValue = [NSNumber numberWithFloat:1.0];
    cellAnimation.fromValue = [NSNumber numberWithFloat:0.01];
    return cellAnimation;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    
    // TODO: decide to keep or loose animation
    CABasicAnimation* cellAnimate = [self cellImageAnimation];
    
    
    
    
    
    
    if (indexPath.row == 0) {
        
        MH_CH_PrimaryImgCell* mainImageCell = [tableView dequeueReusableCellWithIdentifier:@"Primary_Image_Cell"];
        
        mainImageCell.mhid_Primary_Image.image = self.primaryImage;
        
        [mainImageCell.mhid_Primary_Image.layer addAnimation:cellAnimate forKey:@"animateOpacity"];
        
        
        
        
        
        /*
        // TODO: decide to keep or loose animation
        UIGraphicsBeginImageContextWithOptions(mainImageCell.mhid_Primary_Image.bounds.size, NO, 4.0);
        [[UIBezierPath bezierPathWithRoundedRect:mainImageCell.mhid_Primary_Image.bounds cornerRadius:8.0] addClip];
        [self.primaryImage drawInRect:mainImageCell.mhid_Primary_Image.bounds];
        mainImageCell.mhid_Primary_Image.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        */
        
        
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:0.4];
        [mainImageCell setSelectedBackgroundView:bgColorView];
        
        return mainImageCell;
        
    } else {
        
        MH_CH_ContributorCell* contributorCell = [tableView dequeueReusableCellWithIdentifier:@"Contributor_Cell" forIndexPath:indexPath];
        
   
        contributorCell.mhid_Contributor_Image.image = nil;
        
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURL* url = [NSURL URLWithString:self.mediaContributorsImageURLs[indexPath.row - 1]];
                
                NSData* data= [NSData dataWithContentsOfURL:url];
                
                UIImage* img = [UIImage imageWithData:data];
                
                if ([contributorCell.mhid_Contributor_Name.text isEqualToString:self.mediaContributorsName[indexPath.row - 1]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        contributorCell.mhid_Contributor_Image.image = img;
                        
                        
                        
                        if (self.isMedia) {
                         //
                            //TODO: handle animation redrawing which scales it to square instead of a rectangle
                            UIGraphicsBeginImageContextWithOptions(contributorCell.mhid_Contributor_Image.bounds.size, NO, 8.0);
                            [[UIBezierPath bezierPathWithRoundedRect:contributorCell.mhid_Contributor_Image.bounds cornerRadius:4.0] addClip];
                            
                            
                        } else {
                            
                            //TODO: handle animation redrawing which scales it to square instead of a rectangle
                            UIGraphicsBeginImageContextWithOptions(contributorCell.mhid_Contributor_Image.bounds.size, NO, 6.0);
                            [[UIBezierPath bezierPathWithRoundedRect:contributorCell.mhid_Contributor_Image.bounds cornerRadius:40.0] addClip];
                        }
                        
                        [img drawInRect:contributorCell.mhid_Contributor_Image.bounds];
                        contributorCell.mhid_Contributor_Image.image = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        [contributorCell.mhid_Contributor_Image.layer addAnimation:cellAnimate forKey:@"animateOpacity"];
                        
                    });
                    
                }
            });
        
        
        NSString* contributorName = self.mediaContributorsName[indexPath.row - 1];
        if ([contributorName isEqual:[NSNull null]]) {
            contributorName = @" ";
        }
        contributorCell.mhid_Contributor_Name.text = contributorName;
        
        
        NSString* contributorRole = self.mediaContributorsRole[indexPath.row - 1];
        if ([contributorRole isEqual:[NSNull null]]) {
            contributorRole = @" ";
        }
        contributorCell.mhid_Contributor_Role.text = contributorRole;
        
        
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
