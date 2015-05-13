//
//  A_TaskHelper.h
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, A_Task_PriorityType) {
    A_Task_Priority_UI         = 201,
    A_Task_Priority_Hight      = 202,
    A_Task_Priority_Default    = 203,
    A_Task_Priority_Low        = 204,
    A_Task_Priority_Background = 205,
};

typedef NS_ENUM(NSInteger, A_Task_RunningEnvironment) {
    A_Task_RunInBackgroupCompleteInMain     = 211,
    A_Task_RunInMainCompleteInBackgroup     = 212,
    A_Task_RunInBackgroup                   = 213,
    A_Task_RunInMain                        = 214,
};

@interface A_TaskHelper : NSObject

typedef void(^TaskBlock)(A_TaskHelper *task);

+ (void) A_RunInBackground: (dispatch_block_t)block;
+ (void) A_RunInBackground: (dispatch_block_t) block WhenDone: (dispatch_block_t) finishBlock;

+ (void) A_RunInBackgroundWithObj:(id) obj Block:(void (^)(id arg))block;
+ (void) A_RunInBackgroundWithObj:(id) obj Block:(id (^)(id arg))block WhenDone:(void (^)(id arg, id result))finishBlock;

+ (dispatch_source_t) A_StartTimer:(double)seconds Block:(dispatch_block_t) block;
+ (dispatch_source_t) A_StartTimer:(double)seconds Block:(dispatch_block_t) block InMain:(bool)inMain;
+ (void) A_CancelTimer:(dispatch_source_t)timer;

#pragma mark - Task chain

- (id) init;

// default is A_Task_Priority_Default
//@property (nonatomic) A_Task_PriorityType PriorityType;

// Default is running in backgroup thread and complete in main thread
@property (nonatomic) A_Task_RunningEnvironment RunningEnvironment;

@property (nonatomic) bool Sequential;

@property (strong, atomic) id Tag;

+ (A_TaskHelper*) A_Init;
+ (A_TaskHelper*) A_Init: (A_Task_RunningEnvironment)environment Sequential:(bool)sequential;

- (A_TaskHelper*) A_AddTask:(TaskBlock) block;
- (A_TaskHelper*) A_AddDelayTask:(float)seconds;
- (A_TaskHelper*) A_AddDelayTask:(float)seconds Block:(TaskBlock) block;

- (void) A_Execute;
- (void) A_ExecuteWithCompletion:(TaskBlock)block;

@end

