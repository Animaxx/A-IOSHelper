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
@property (retain, nonatomic) NSString *Description;

@end
@implementation SecondDataModel
@end



@interface MappingTests : XCTestCase

@end

@implementation MappingTests

-(void)testMapping {
    [[[A_Mapper A_Instance] A_CreateMap:[TestDataModel class] To:[SecondDataModel class]] A_AddMemeber:@"Name" To:@"Name"];
}

@end
