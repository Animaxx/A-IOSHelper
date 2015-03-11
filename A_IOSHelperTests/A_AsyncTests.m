//
//  A_AsyncTests.m
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "A_AsyncHelper.h"

@interface A_AsyncTests : XCTestCase

@end

@implementation A_AsyncTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


int _testInt = 0;
- (void)testRunInBackground {
    _testInt = 0;
    [A_AsyncHelper A_RunInBackground: ^(void) {
        _testInt = 1;
    }];
    
    sleep(500);
    XCTAssert(_testInt==1);
}

- (void)testRunInBackgroundWithDone {
    _testInt = 0;
    
    [A_AsyncHelper A_RunInBackground:^{
        _testInt = 1;
        NSLog(@"Step 1");
    } WhenDone:^{
        _testInt = 2;
        NSLog(@"Step 2");
    }];
    
    XCTAssert(YES);
}


- (void)testDelayExecute {
    _testInt = 0;
    [A_AsyncHelper A_DelayExecute:0.1 Method: ^(void) {
        _testInt = 1;
    }];
    
    sleep(500);
    XCTAssert(YES);
}

@end
