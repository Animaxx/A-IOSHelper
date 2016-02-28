//
//  MappingTests.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/7/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TestDataModel.h"
#import "A_Mapper.h"
#import "NSString+A_Extension.h"

//////////////////
// Test Models
//////////////////

// Input 2Lv Model
@interface Input2lvModel : NSObject
@property (strong, nonatomic) NSString *ModelDescription;
@end
@implementation Input2lvModel
@end

// Input Model
@interface InputDataModel : NSObject
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) Input2lvModel *lv2;
@end
@implementation InputDataModel
@end

// Output 2Lv Model
@interface Output2lvModel : NSObject
@property (strong, nonatomic) NSString *Explanation;
@end
@implementation Output2lvModel
@end

// Output Model
@interface OutputDataModel : NSObject
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *ModelDescription;
@property (strong, nonatomic) Input2lvModel *lv2;
@end
@implementation OutputDataModel
@end


//////////////////
// Unit Test
//////////////////

@interface MappingTests : XCTestCase

@end

@implementation MappingTests

-(void)testOneLvDirectMapping {
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMap:[InputDataModel class] To:[OutputDataModel class]];
    [map A_SetMemeber:@"Name" To:@"Name"];
    [map A_SetMemeber:@"ID" To:@"ID"];
    
    InputDataModel *sourceModel = [InputDataModel new];
    sourceModel.Name = @"name";
    sourceModel.ID = @(10);
    
    OutputDataModel *outputModel = [[A_Mapper A_Instance] A_Convert:sourceModel ToClassName:@"OutputDataModel"];
    
    XCTAssertEqual(outputModel.Name, sourceModel.Name);
    XCTAssertEqual(outputModel.ID, sourceModel.ID);
}

-(void)testSecondLvToFirstLvDirectMapping {
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMap:[InputDataModel class] To:[OutputDataModel class]];
    [map A_SetMemeber:@"Name" To:@"Name"];
    [map A_SetMemeber:@"ID" To:@"ID"];
    [map A_SetMemeber:@"lv2.ModelDescription" To:@"ModelDescription"];
    
    InputDataModel *sourceModel = [InputDataModel new];
    sourceModel.Name = @"name";
    sourceModel.ID = @(10);
    sourceModel.lv2 = [Input2lvModel new];
    sourceModel.lv2.ModelDescription = @"Description";
    
    OutputDataModel *outputModel = [[A_Mapper A_Instance] A_Convert:sourceModel ToClassName:@"OutputDataModel"];
    
    XCTAssertEqual(outputModel.Name, sourceModel.Name);
    XCTAssertEqual(outputModel.ID, sourceModel.ID);
    XCTAssertEqual(outputModel.ModelDescription, sourceModel.lv2.ModelDescription);
}

-(void)testConvertFromJSON {
    NSString *json = @"{\"Name\": \"name\",\"ID\": \"5\",\"lv2\": {\"ModelDescription\": \"description\"} }";
    NSDictionary *jsonDic = [json A_CovertJSONToDictionary];
    
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMap:[NSDictionary class] To:[OutputDataModel class]];
    [map A_SetMemeber:@"Name" To:@"Name"];
    [map A_SetMemeber:@"ID" To:@"ID"];
    [map A_SetMemeber:@"lv2.ModelDescription" To:@"ModelDescription"];
    
    OutputDataModel *outputModel = [[A_Mapper A_Instance] A_Convert:jsonDic ToClassName:@"OutputDataModel"];
    
    XCTAssertEqual(outputModel.Name, [jsonDic objectForKey:@"Name"]);
    XCTAssertEqual(outputModel.ID, [jsonDic objectForKey:@"ID"]);
    XCTAssertEqual(outputModel.ModelDescription, [jsonDic valueForKeyPath:@"lv2.ModelDescription"]);
}

@end
