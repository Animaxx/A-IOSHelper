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
    
    [_list1 A_Swap:_list2];
    
    XCTAssertEqual([_list1 objectAtIndex:0] , @"1");
    XCTAssertEqual([_list1 objectAtIndex:1] , @"2");
    XCTAssertEqual([_list1 objectAtIndex:2] , @"3");
    
    XCTAssertEqual([_list2 objectAtIndex:0] , @"A");
    XCTAssertEqual([_list2 objectAtIndex:1] , @"B");
    XCTAssertEqual([_list2 objectAtIndex:2] , @"C");
}
- (void)testSkipTake {
    NSArray* _list = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    
    NSArray* test1 = [_list A_Skip:5];
    XCTAssertEqual([test1 objectAtIndex:0] , @6);
    XCTAssertEqual([test1 count], 5);

    NSArray* test2 = [[_list A_Skip:4] A_Take:3];
    XCTAssertEqual([test2 objectAtIndex:0] , @5);
    XCTAssertEqual([test2 count], 3);
    
    NSArray* test3 = [[_list A_Skip:8] A_Take:10];
    XCTAssertEqual([test3 objectAtIndex:0] , @9);
    XCTAssertEqual([test3 count], 2);
    
    NSArray* test4 = [_list A_Skip:10];
    XCTAssertEqual([test4 count], 0);
}
- (void)testReverse {
    NSArray* _list = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    NSArray* _test = [_list A_Reverse];
    
    for (NSUInteger i=0; i<[_list count]; i++) {
        XCTAssertEqual([_list objectAtIndex:i], [_test objectAtIndex:[_test count]-1-i]);
    }
}
- (void)testWhere {
    NSArray* _list = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    NSArray* _test = [_list A_Where:^bool(NSNumber* x) {
        return [x integerValue] > 5 && [x integerValue] < 9;
    }];
    XCTAssertEqual([_test firstObject], @6);
    XCTAssertEqual([_test lastObject], @8);
    XCTAssertEqual([_test count], 3);
}
- (void)testAny {
    NSArray* _list = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    XCTAssertTrue([_list A_Any:^bool(NSNumber* x) {
        return [x integerValue] == 9;
    }]);
    XCTAssertFalse([_list A_Any:^bool(NSNumber* x) {
        return [x integerValue] == 0;
    }]);
}
- (void)testFirstLast {
    NSArray* _list = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    NSNumber* _first = [_list A_FirstOrNil:^bool(NSNumber* x) {
        return [x integerValue] % 2 ==0;
    }];
    NSNumber* _last = [_list A_LastOrNil:^bool(NSNumber* x) {
        return [x integerValue] % 2 ==0;
    }];
    NSNumber* _nil = [_list A_FirstOrNil:^bool(NSNumber* x) {
        return [x integerValue] < 0;
    }];
    
    XCTAssertEqual(_first, @2);
    XCTAssertEqual(_last, @10);
    XCTAssertNil(_nil);
}

@end



