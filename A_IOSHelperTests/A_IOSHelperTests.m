//
//  A_IOSHelperTests.m
//  A_IOSHelperTests
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "A_StringHelper.h"

@interface A_IOSHelperTests : XCTestCase

@end

@implementation A_IOSHelperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // All Passed

//    BOOL _a = [A_StringHelper A_ValidateEmail:@"abc@123"];
    
    XCTAssert(YES, @"Pass");
}

@end
