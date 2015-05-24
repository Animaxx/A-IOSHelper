//
//  CollectionTests.m
//  A_IOSHelper
//
//  Created by Animax on 5/24/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "A_CollectionHelper.h"
#import "NSArray+A_Extension.h"
#import "NSDictionary+A_Extension.h"
#import "NSMutableArray+A_Extension.h"
#import "NSMutableDictionary+A_Extension.h"
#import "NSString+A_Extension.h"

@interface CollectionTests : XCTestCase

@end

@implementation CollectionTests

- (void)testMakingDictionary {
    NSArray* _list = @[@"A",@"B",@"C"];
    NSDictionary* test1 = [_list A_CombineKeys:@[@"K1",@"K2",@"K3"]];
    
    XCTAssertEqual([test1 objectForKey:@"K1"] , @"A");
    XCTAssertEqual([test1 objectForKey:@"K2"] , @"B");
    XCTAssertEqual([test1 objectForKey:@"K3"] , @"C");
    
    NSDictionary* test2 = [_list A_CombineValues:@[@"V1",@"V2",@"V3"]];
    XCTAssertEqual([test2 objectForKey:@"A"] , @"V1");
    XCTAssertEqual([test2 objectForKey:@"B"] , @"V2");
    XCTAssertEqual([test2 objectForKey:@"C"] , @"V3");
}
- (void)testSwap {
    NSMutableArray* _list1 = [[NSMutableArray alloc] initWithArray:@[@"A",@"B",@"C"]];
    NSMutableArray* _list2 = [[NSMutableArray alloc] initWithArray:@[@"1",@"2",@"3"]];
    
    [_list1 A_SwapWith:_list2];
    
    XCTAssertEqual([_list1 objectAtIndex:0] , @"1");
    XCTAssertEqual([_list1 objectAtIndex:1] , @"2");
    XCTAssertEqual([_list1 objectAtIndex:2] , @"3");
    
    XCTAssertEqual([_list2 objectAtIndex:0] , @"A");
    XCTAssertEqual([_list2 objectAtIndex:1] , @"B");
    XCTAssertEqual([_list2 objectAtIndex:2] , @"C");
}



@end
