//
//  A_AsyncTests.m
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "A_TaskHelper.h"

@interface A_AsyncTests : XCTestCase

@end

@implementation A_AsyncTests

int _testInt = 0;

- (void)testRunInBackgroundWithDone {
    _testInt = 0;
    
    [A_TaskHelper A_RunInBackground:^{
        _testInt = 1;
        NSLog(@"Step 1");
    } WhenDone:^{
        XCTAssertEqual(1, _testInt);
    }];
}

- (void)testRunInBackgroundWithObj {
    NSString* _message = @"test";
    
    [A_TaskHelper A_RunInBackgroundWithObj:_message Block:^id(id arg) {
        return [arg stringByAppendingString:@"123"];
    } WhenDone:^(id arg, id result) {
        XCTAssertEqual(@"123", result);
    }];
    
    XCTAssert(YES);
}

- (void)testDelayExecute {
    _testInt = 0;
    [A_TaskHelper A_StartTimer:0.3f Block:^{
        _testInt = 1;
    } InMain:NO];
    
    sleep(1);
    XCTAssert(1==_testInt);
}

- (void)testSquentialTaskChain {
    NSMutableArray *_list = [[NSMutableArray alloc] init];
    NSMutableArray *_list2 = [[NSMutableArray alloc] init];
    
    A_TaskHelper* task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:YES];
    for (int i = 0; i<10; i++) {
        [task A_AddTask:^(A_TaskHelper *task) {
            [NSThread sleepForTimeInterval:((float)((arc4random() % (100 - i*4))) / 100)];
            [_list addObject:@(i)];
            NSLog(@"%d",i);
        }];
    }
    
    A_TaskHelper* task2 = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:YES];
    for (int i = 0; i<10; i++) {
        [task2 A_AddTask:^(A_TaskHelper *task) {
            [NSThread sleepForTimeInterval:((float)((arc4random() % (100 - i*4))) / 100)];
            [_list2 addObject:@(i)];
            NSLog(@"Task 2 %d",i);
        }];
    }
    
    [task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        NSLog(@"--- Queue 1 completed");
        XCTAssertEqual([_list firstObject], @(0));
        XCTAssertEqual([_list lastObject], @(9));
        XCTAssertEqual([_list count], 10);
    }];
    [task2 A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        NSLog(@"--- Queue 2 completed");
        XCTAssertEqual([_list2 firstObject], @(0));
        XCTAssertEqual([_list2 lastObject], @(9));
        XCTAssertEqual([_list2 count], 10);
    }];
    
    sleep(10);
}

- (void)testConcurrentSquentialTaskChain {
    NSMutableArray *_list = [[NSMutableArray alloc] init];
    
    A_TaskHelper* task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:NO];
    for (int i = 0; i<10; i++) {
        [task A_AddTask:^(A_TaskHelper *task) {
            [NSThread sleepForTimeInterval:((float)((arc4random() % (100 - i*4))) / 100)];
            [_list addObject:@(i)];
            NSLog(@"%d",i);
        }];
    }
    [task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        NSLog(@"---------------- Completion");
        XCTAssertEqual([_list count], 10);
    }];
    
    sleep(3);
}

- (void)testDelayTaskChain {
    NSMutableArray *_list = [[NSMutableArray alloc] init];
    
    A_TaskHelper* task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:NO];
    for (int i = 0; i<10; i++) {
        float delay = (float)((arc4random() % (100 - i*4))) / 100;
        [task A_AddDelayTask:delay Block:^(A_TaskHelper *task) {
            [_list addObject:@(i)];
            NSLog(@"%d",i);
        }];
    }
    [task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        NSLog(@"---------------- Completion");
        XCTAssertEqual([_list count], 10);
    }];
    
    sleep(3);
}


@end
