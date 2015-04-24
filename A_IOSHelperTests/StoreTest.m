//
//  StoreTest.m
//  A_IOSHelper
//
//  Created by Animax on 4/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "A_UserDatafileHelper.h"
#import "TestDataModel.h"

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
    [A_UserDatafileHelper A_Save:@"abc" byKey:@"Key"];
    NSString* _value = [A_UserDatafileHelper A_GetByKey:@"Key"];
    
    XCTAssertNotNil(_value);
}

- (void)testGetAndSetToGroupFile {
    [A_UserDatafileHelper A_Save:@"abc" toGroup:@"group" andKey:@"Key"];
    NSString* _value = [A_UserDatafileHelper A_GetByGroup:@"group" andKey:@"Key"];
    
    XCTAssertNotNil(_value);
    
    NSString* _value2 = [A_UserDatafileHelper A_GetByKey:@"Key"];
    XCTAssertNotEqual(_value, _value2);
}

- (void)testDeleteCache {
    [A_UserDatafileHelper A_Save:@"abc" byKey:@"Key"];
    NSString* _value = [A_UserDatafileHelper A_GetByKey:@"Key"];
    
    XCTAssertNotNil(_value);
    
    [A_UserDatafileHelper A_CleanAll];
    _value = [A_UserDatafileHelper A_GetByKey:@"Key"];
    XCTAssertNil(_value);
}

- (void)testDeleteCacheInGroup {
    [A_UserDatafileHelper A_Save:@"abc" toGroup:@"group" andKey:@"Key"];
    NSString* _value = [A_UserDatafileHelper A_GetByGroup:@"group" andKey:@"Key"];
    
    XCTAssertNotNil(_value);
    
    [A_UserDatafileHelper A_CleanAllInGroup:@"group"];
    _value = [A_UserDatafileHelper A_GetByGroup:@"group" andKey:@"Key"];
    XCTAssertNil(_value);
}

- (void)testHandleDatamodel {
    [TestDataModel A_ClearFromUserfile];
    
    TestDataModel* _model1 = [[TestDataModel alloc] init];
    [_model1 setName:@"Object_1"];
    [_model1 setCreateDate: [NSDate date]];
    [_model1 setID:@0];
    [_model1 A_SaveToUserfile];
    XCTAssertTrue([TestDataModel A_GetFromUserfile].count == 1);
    XCTAssertTrue([((TestDataModel*)[TestDataModel A_GetFromUserfile].firstObject).Name isEqualToString:@"Object_1"]);
    
    TestDataModel* _model2 = [[TestDataModel alloc] init];
    [_model2 setIndex:1];
    [_model2 setName:@"Object_2"];
    [_model2 setCreateDate: [NSDate date]];
    [_model2 setID:@1];
    [_model2 A_SaveToUserfile];
    XCTAssertTrue([TestDataModel A_GetFromUserfile].count == 2);
    XCTAssertTrue([((TestDataModel*)[TestDataModel A_GetFromUserfile].lastObject).Name isEqualToString:@"Object_2"]);
}

@end
