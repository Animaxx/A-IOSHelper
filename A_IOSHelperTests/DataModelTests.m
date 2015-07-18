//
//  A_DataModelTests.m
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TestDataModel.h"

@interface DataModelTests : XCTestCase

@end

@implementation DataModelTests

- (void)testSerialize {
    TestDataModel *_test = [[TestDataModel alloc] init];
    
    NSDictionary *_d = [_test A_Serialize];
    TestDataModel *_result = (TestDataModel*)[TestDataModel A_Deserialize:_d];
    
    XCTAssertNotNil(_result);
}

- (void)testConvertJSON {
    TestDataModel *_test = [[TestDataModel alloc] init];
    _test.Name = @"Test2";
    _test.CreateDate = [NSDate date];
    _test.Index = 100;
    _test.ID = [NSNumber numberWithInt:123];
    
    NSString *_d = [_test A_ConvertToJSON];
    TestDataModel *_result = (TestDataModel*)[TestDataModel A_ConvertFromJSON:_d];
    
    XCTAssertNotNil(_result);
}


@end
