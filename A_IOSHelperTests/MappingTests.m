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

@interface SecondDataModel : NSObject

@property (retain, nonatomic) NSString *Name;
@property (retain, nonatomic) NSNumber *ID;

@end
@implementation SecondDataModel
@end



@interface MappingTests : XCTestCase

@end

@implementation MappingTests

-(void)testMapping {
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMap:[TestDataModel class] To:[SecondDataModel class]];
    [map A_AddMemeber:@"Name" To:@"Name"];
    [map A_AddMemeber:@"ID" To:@"ID"];
    
    TestDataModel *sourceModel = [TestDataModel new];
    sourceModel.Name = @"name";
    sourceModel.ID = @(10);
    
    SecondDataModel *outputModel = [[A_Mapper A_Instance] A_Convert:sourceModel ToClassName:@"SecondDataModel"];
    
    XCTAssertEqual(outputModel.Name, sourceModel.Name);
    XCTAssertEqual(outputModel.ID, sourceModel.ID);
}

@end
