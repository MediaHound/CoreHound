//
//  MHObject-Tests.m
//  CoreHoundTests
//
//  Created by Dustin Bachrach on 10/23/15.
//  Copyright © 2015 Dustin Bachrach. All rights reserved.
//

#import <CoreHound/MHApi.h>


SpecBegin(MHObjectSpecs)

describe(@"MHObject", ^{
    
    it(@"can fetch well know mhids", ^{
        waitUntil(^(DoneCallback done) {
            NSString* mhid = @"mhmovPCmKj8zuQbGYVDDB4jgOmDHQ8qx0PnUR5gFALYP";
            [MHObject fetchByMhid:mhid].then(^(MHObject* obj) {
                expect(obj.metadata.mhid).to.equal(mhid);
                expect(obj.metadata.name).to.equal(@"The Sound of Music");
                done();
            }).catch(^(NSError* error) {
                failure(@"MHObject fetchByMhid failed");
                done();
            });
        });
    });
    
    it(@"should fail to fetch an mhid that does not exist", ^{
        waitUntil(^(DoneCallback done) {
            NSString* mhid = @"mhmovXXXXX8zuQbGYVDDB4jgOmDHQ8qx0PnUR5gXXXXX";
            [MHObject fetchByMhid:mhid].then(^(MHObject* obj) {
                failure(@"MHObject fetchByMhid should have failed with unknown mhid");
                done();
            }).catch(^(NSError* error) {
                done();
            });
        });
    });
});

SpecEnd
