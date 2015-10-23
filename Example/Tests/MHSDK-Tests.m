//
//  MHSDK-Tests.m
//  CoreHoundTests
//
//  Created by Dustin Bachrach on 03/02/2015.
//  Copyright (c) 2014 Dustin Bachrach. All rights reserved.
//

#import <CoreHound/MHApi.h>


SpecBegin(MHSDKSpecs)

describe(@"MHSDK", ^{
    
    it(@"can configure with a client id and secret", ^{
        waitUntil(^(DoneCallback done) {
            [[MHSDK sharedSDK] configureWithClientId:@"mhclt_MHLite"
                                        clientSecret:@"1YIdQRqKtvQMmt3t0qZwVc1Tg2dDRheCLjhvODxloO686whQ"].then(^() {
                done();
            }).catch(^(NSError* error) {
                failure(@"MHSDK configure failed");
                done();
            });
        });
    });
    
    it(@"should fail to configure with an invalid client id and secret", ^{
        waitUntil(^(DoneCallback done) {
            [[MHSDK sharedSDK] configureWithClientId:@""
                                        clientSecret:@""].then(^() {
                failure(@"MHSDK configured succesfully even though it has an invalid id and secret");
                done();
            }).catch(^(NSError* error) {
                done();
            });
        });
    });
});

SpecEnd
