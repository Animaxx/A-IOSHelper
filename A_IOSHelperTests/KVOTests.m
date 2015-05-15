//
//  KVOTest.m
//  A_IOSHelper
//
//  Created by Animax on 5/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSObject+A_KVO_Extension.h"
#import "TestDataModel.h"

@interface KVOTests : XCTestCase

@end

@implementation KVOTests

- (void) testKVO {
    TestDataModel* _model = [[TestDataModel alloc] init];

    [_model A_AddObserver:@"Name" Option:NSKeyValueObservingOptionNew block:^(NSObject *itself, NSDictionary *change) {
        XCTAssertTrue([[change objectForKey:@"new"] isEqualToString:@"A"]);
    }];
    
    [_model setName:@"A"];
    [_model A_RemoveObserver:@"Name"];
    [_model setName:@"B"];
}


@end
