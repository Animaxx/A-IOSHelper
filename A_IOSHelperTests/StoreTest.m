//
//  StoreTest.m
//  A_IOSHelper
//
//  Created by Animax on 4/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "A_StoreDatafileHelper.h"

@interface StoreTest : XCTestCase

@end

@implementation StoreTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAndSetToFile {
    [A_StoreDatafileHelper A_SaveObjectToDatafile:@"Key" dataObject:@"abc"];
    NSString* _value = [A_StoreDatafileHelper A_GetObjectFromDatafile:@"Key"];
    
    XCTAssertNotNil(_value);
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
