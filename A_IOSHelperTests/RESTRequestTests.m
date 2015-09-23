//
//  RESTRequestTests.m
//  A_IOSHelper
//
//  Created by Animax Deng on 9/18/15.
//  Copyright © 2015 AnimaxDeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "A_RESTRequest.h"

@interface RESTRequestTests : XCTestCase

@end

@implementation RESTRequestTests

#define TestingWebservice @"http://jsonplaceholder.typicode.com/posts"

- (void)testRESTSimpleGet {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Time out"];
    [[A_RESTRequest A_Create:TestingWebservice] A_RequestArray:^(NSArray *data, NSURLResponse *response, NSError *error) {
        XCTAssertGreaterThanOrEqual(data.count, 1);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)testRESTSimplePost {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Time out"];
    [[A_RESTRequest A_Create:TestingWebservice method:A_Network_POST parameters:@{@"title": @"foo", @"body": @"bar", @"userId": @(10)} format:A_Network_SendAsJSON] A_RequestDictionary:^(NSDictionary *data, NSURLResponse *response, NSError *error) {
        XCTAssertGreaterThanOrEqual(data.count, 1);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


@end
