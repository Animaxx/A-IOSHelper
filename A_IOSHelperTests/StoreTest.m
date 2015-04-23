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
    TestDataModel* _model = [[TestDataModel alloc] init];
}

@end
