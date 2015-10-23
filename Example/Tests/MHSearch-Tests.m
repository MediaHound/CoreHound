//
//  MHSearch-Tests.m
//  CoreHound
//
//  Created by Dustin Bachrach on 10/23/15.
//  Copyright © 2015 Dustin Bachrach. All rights reserved.
//

#import <CoreHound/MHApi.h>


SpecBegin(MHSearchSpecs)

describe(@"MHSearch", ^{
    
    it(@"returns empty results for the empty string", ^{
        waitUntil(^(DoneCallback done) {
            [MHSearch fetchResultsForSearchTerm:@"" scope:MHSearchScopeAll].then(^(MHPagedResponse* response) {
                expect(response.content).to.beEmpty();
                done();
            }).catch(^(NSError* error) {
                failure(@"MHSearch for empty failed");
                done();
            });
        });
    });
    
    it(@"returns results for a string", ^{
        waitUntil(^(DoneCallback done) {
            [MHSearch fetchResultsForSearchTerm:@"a" scope:MHSearchScopeAll].then(^(MHPagedResponse* response) {
                expect(response.content).toNot.beEmpty();
                done();
            }).catch(^(NSError* error) {
                failure(@"MHSearch for empty failed");
                done();
            });
        });
    });
    
    it(@"returns results of the correct scope", ^{
        waitUntil(^(DoneCallback done) {
            [MHSearch fetchResultsForSearchTerm:@"a" scope:MHSearchScopeMovie].then(^(MHPagedResponse* response) {
                expect(response.content).toNot.beEmpty();
                for (MHRelationalPair* pair in response.content) {
                    expect(pair.object).to.beKindOf(MHMovie.class);
                }
                done();
            }).catch(^(NSError* error) {
                failure(@"MHSearch for empty failed");
                done();
            });
        });
    });
    
    it(@"returns results of the correct scope with multiple scopes", ^{
        waitUntil(^(DoneCallback done) {
            [MHSearch fetchResultsForSearchTerm:@"a" scope:MHSearchScopeMovie|MHSearchScopeShowSeries].then(^(MHPagedResponse* response) {
                expect(response.content).toNot.beEmpty();
                for (MHRelationalPair* pair in response.content) {
                    if (![pair.object isKindOfClass:MHMovie.class] && ![pair.object isKindOfClass:MHShowSeries.class]) {
                        failure(@"search response contained an object that was not a movie nor show series");
                    }
                }
                done();
            }).catch(^(NSError* error) {
                failure(@"MHSearch for empty failed");
                done();
            });
        });
    });
});

SpecEnd