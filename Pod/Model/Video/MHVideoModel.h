//
//  VideoModel.h
//  mediaHound
//
//  Created by Dustin Bachrach on 3/26/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface MHVideoModel : JSONModel

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSURL* primaryImageURL;
@property (strong, nonatomic) NSURL* videoURL;

@end
