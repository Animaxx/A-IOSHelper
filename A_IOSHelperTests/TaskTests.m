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

@interface TaskTests : XCTestCase

@end

@implementation TaskTests

- (void)testRunInBackgroundWithDone {
    [A_TaskHelper A_RunInBackground:^id{
        NSLog(@"Step 1");
        return @(1);
    } WhenDone:^(id arg) {
        XCTAssertEqual(@(1), arg);
    }];
}

- (void)testRunInBackgroundWithObj {
    NSString *_message = @"test";
    
    [A_TaskHelper A_RunInBackgroundWithParam:_message Block:^id(id arg) {
        return [arg stringByAppendingString:@"123"];
    } WhenDone:^(id arg, id result) {
        XCTAssertEqual(@"123", result);
    }];
}

- (void)testDelayExecute {
    __block BOOL testBool = YES;
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Time out"];
    [A_TaskHelper A_StartTimer:0.3f Block:^{
        testBool = YES;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
    XCTAssertTrue(testBool);
}

- (void)testSquentialTaskChain {
    NSMutableArray *_list = [[NSMutableArray alloc] init];
    NSMutableArray *_list2 = [[NSMutableArray alloc] init];
    
    A_TaskHelper *task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:YES];
    for (int i = 0; i<10; i++) {
        [task A_AddTask:^(A_TaskHelper *task) {
            [NSThread sleepForTimeInterval:((float)((arc4random() % (100 - i*4))) / 100)];
            [_list addObject:@(i)];
            NSLog(@"%d",i);
        }];
    }
    
    A_TaskHelper *task2 = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:YES];
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
    
    A_TaskHelper *task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:NO];
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
    
    A_TaskHelper *task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:NO];
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

- (void) testTaskChainEitherInSeuquential {
    A_TaskHelper *task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:NO];
    [task A_AddDelayTask:2.0f Block:^(A_TaskHelper *task) {
            NSLog(@"Task %d",1);
    }];
    [task A_AddDelayTask:1.0f Block:^(A_TaskHelper *task) {
            NSLog(@"Task %d",2);
    }];
    [task A_AddTask:^(A_TaskHelper *task) {
            NSLog(@"Task %d",3);
    }];
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    [task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"operation took %2.5f seconds", end-start);
    }];
    
    sleep(10);
}

- (void) testMultiTaskChain {
    A_TaskHelper *task = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:NO];
    [task A_AddDelayTask:2.0f Block:^(A_TaskHelper *task) {
        NSLog(@"Task %d",1);
    }];
    [task A_AddDelayTask:1.0f Block:^(A_TaskHelper *task) {
        NSLog(@"Task %d",2);
    }];
    [task A_AddTask:^(A_TaskHelper *task) {
        NSLog(@"Task %d",3);
    }];
    
    A_TaskHelper *task2 = [A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:YES];
    [task2 A_AddTask:^(A_TaskHelper *task) {
        NSLog(@"Task2 %d",1);
    }];
    [task2 A_AddDelayTask:1.0f Block:^(A_TaskHelper *task) {
        NSLog(@"Task2 %d",2);
    }];
    [task2 A_AddTask:^(A_TaskHelper *task) {
        NSLog(@"Task2 %d",3);
    }];
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    [task2 A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"operation took %2.5f seconds", end-start);
    }];
    
    [task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"operation took %2.5f seconds", end-start);
    }];
    
    sleep(5);
}

- (void) testTaskChain {
    [[[[A_TaskHelper A_Init:A_Task_RunInBackgroup Sequential:YES] A_AddTask:^(A_TaskHelper *task) {
        task.tag = @(1);
    }] A_AddTask:^(A_TaskHelper *task) {
        task.tag = @([((NSNumber*)task.tag) integerValue] + 1);
    }] A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        NSLog(@"Tag: %@", task.tag);
        XCTAssertEqual(@(2), task.tag);
    }];
}

@end
