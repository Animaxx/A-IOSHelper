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

#define TestingWebservice @"http://jsonplaceholder.typicode.com"

- (void)testRESTSimpleGet {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Time out"];
    [[A_RESTRequest A_Create:@"http://jsonplaceholder.typicode.com/posts"] A_RequestArray:^(NSArray *data, NSURLResponse *response, NSError *error) {
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
