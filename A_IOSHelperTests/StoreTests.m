//
//  StoreTest.m
//  A_IOSHelper
//
//  Created by Animax on 4/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "A_PlistHelper.h"
#import "TestDataModel.h"
#import "A_SqliteManager.h"

@interface StoreTests : XCTestCase

@end

@implementation StoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAndSetToFile {
    [A_PlistHelper A_Save:@"abc" byKey:@"Key"];
    NSString* _value = [A_PlistHelper A_GetByKey:@"Key"];
    
    XCTAssertNotNil(_value);
}

- (void)testGetAndSetToGroupFile {
    [A_PlistHelper A_Save:@"abc" toGroup:@"group" andKey:@"Key"];
    NSString* _value = [A_PlistHelper A_GetByGroup:@"group" andKey:@"Key"];
    
    XCTAssertNotNil(_value);
    
    NSString* _value2 = [A_PlistHelper A_GetByKey:@"Key"];
    XCTAssertNotEqual(_value, _value2);
}

- (void)testDeleteCache {
    [A_PlistHelper A_Save:@"abc" byKey:@"Key"];
    NSString* _value = [A_PlistHelper A_GetByKey:@"Key"];
    
    XCTAssertNotNil(_value);
    
    [A_PlistHelper A_CleanAll];
    _value = [A_PlistHelper A_GetByKey:@"Key"];
    XCTAssertNil(_value);
}

- (void)testDeleteCacheInGroup {
    [A_PlistHelper A_Save:@"abc" toGroup:@"group" andKey:@"Key"];
    NSString* _value = [A_PlistHelper A_GetByGroup:@"group" andKey:@"Key"];
    
    XCTAssertNotNil(_value);
    
    [A_PlistHelper A_CleanAllInGroup:@"group"];
    _value = [A_PlistHelper A_GetByGroup:@"group" andKey:@"Key"];
    XCTAssertNil(_value);
}

- (void)testHandleDatamodel {
    [TestDataModel A_ClearFromPlist];
    
    TestDataModel* _model1 = [[TestDataModel alloc] init];
    [_model1 setName:@"Object_1"];
    [_model1 setCreateDate: [NSDate date]];
    [_model1 setID:@0];
    [_model1 A_SaveToPlist];
    
    XCTAssertTrue([TestDataModel A_GetFromPliste].count == 1);
    XCTAssertTrue([((TestDataModel*)[TestDataModel A_GetFromPliste].firstObject).Name isEqualToString:@"Object_1"]);
    
    TestDataModel* _model2 = [[TestDataModel alloc] init];
    [_model2 setIndex:1];
    [_model2 setName:@"Object_2"];
    [_model2 setCreateDate: [NSDate date]];
    [_model2 setID:@1];
    [_model2 A_SaveToPlist];
    XCTAssertTrue([TestDataModel A_GetFromPliste].count == 2);
    XCTAssertTrue([((TestDataModel*)[TestDataModel A_GetFromPliste].lastObject).Name isEqualToString:@"Object_2"]);
    
    [_model2 A_DeleteInPlist];
    XCTAssertTrue([TestDataModel A_GetFromPliste].count == 1);
    XCTAssertTrue([((TestDataModel*)[TestDataModel A_GetFromPliste].lastObject).Name isEqualToString:@"Object_1"]);
}

- (void)testDatamodelWithSql {
    
    TestDataModel* _model1 = [[TestDataModel alloc] init];
    [_model1 setIndex:0];
    [_model1 setName:@"Object_1"];
    [_model1 setCreateDate: [NSDate date]];
    [_model1 setID:@0];
    
    [[A_SqliteManager A_Instance] A_ExecuteQuery:[NSString stringWithFormat:@"DROP TABLE %@", [A_SqliteManager A_GenerateTableName:_model1]]];
    
    [_model1 A_SaveToSqlite];
    
    [_model1 A_SearchSimilarModelsInSqliteWithBlock:^(id obj, NSArray *result) {
        XCTAssertTrue(result.count == 1);
    } andArg:nil];
    
    [TestDataModel A_SearchSqlite:@"" withBlock:^(id obj, NSArray *result) {
        
    } andArg:nil];
    
    XCTAssertTrue([TestDataModel A_SearchSqlite:@""].count == 1);
    XCTAssertTrue([_model1 A_SearchSimilarModelsInSqlite].count == 1);
}

@end
