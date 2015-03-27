//
//  A_AsyncHelper.h
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, A_Async_PriorityType) {
    A_Async_Priority_UI         = 201,
    A_Async_Priority_Hight      = 202,
    A_Async_Priority_Default    = 203,
    A_Async_Priority_Low        = 204,
    A_Async_Priority_Background = 205,
};

@interface A_AsyncHelper : NSObject

+ (void) A_RunInBackground: (dispatch_block_t)block;
+ (void) A_RunInBackground: (dispatch_block_t) block WhenDone: (dispatch_block_t) finishBlock;

+ (void) A_RunInBackgroundWithObj:(id) obj Block:(void (^)(id arg))block;
+ (void) A_RunInBackgroundWithObj:(id) obj Block:(id (^)(id arg))block WhenDone:(void (^)(id arg, id result))finishBlock;

+ (void) A_DelayExecute:(dispatch_block_t) method Delay:(double) delaySec;
+ (void) A_DelayExecuteWithObj:(id)obj Method: (void (^)(id arg))method Delay:(double) delaySec;

+ (dispatch_source_t) A_StartTimer:(double)interval Block:(dispatch_block_t) block;
+ (dispatch_source_t) A_StartTimer:(double)interval Block:(dispatch_block_t) block Priority:(A_Async_PriorityType)PriorityType;
+ (void) A_CancelTimer:(dispatch_source_t)timer;

@end
