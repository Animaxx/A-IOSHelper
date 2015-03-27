//
//  A_AsyncHelper.m
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_AsyncHelper.h"

@implementation A_AsyncHelper

+ (void) A_RunInBackground: (dispatch_block_t) block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
+ (void) A_RunInBackground: (dispatch_block_t) block WhenDone: (dispatch_block_t) finishBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        block();
        dispatch_async(dispatch_get_main_queue(), finishBlock);
    });
}

+ (void) A_RunInBackgroundWithObj:(id) obj Block:(void (^)(id arg))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        block(obj);
    });
}
+ (void) A_RunInBackgroundWithObj:(id) obj Block:(id (^)(id arg))block WhenDone:(void (^)(id arg, id result))finishBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        id result = block(obj);
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            finishBlock(obj,result);
        });
    });
}

+ (void) A_DelayExecute:(dispatch_block_t) method Delay:(double) delaySec{
//+ (void) A_DelayExecute: (double) delaySec Method: (dispatch_block_t) method {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), method);
}
+ (void) A_DelayExecuteWithObj:(id)obj Method: (void (^)(id arg))method Delay:(double) delaySec{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        method(obj);
    });
}

+ (dispatch_source_t) A_StartTimer:(double)interval Block:(dispatch_block_t) block {
    return [self A_StartTimer:interval Block:block Priority:A_Async_Priority_Default];
}
+ (dispatch_source_t) A_StartTimer:(double)interval Block:(dispatch_block_t) block Priority:(A_Async_PriorityType)PriorityType {
    dispatch_queue_t queue;
    switch (PriorityType) {
        case A_Async_Priority_UI:
            queue = dispatch_get_main_queue();
            break;
        case A_Async_Priority_Hight:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            break;
        case A_Async_Priority_Default:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            break;
        case A_Async_Priority_Low:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            break;
        case A_Async_Priority_Background:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            break;
        default:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            break;
    }
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}
+ (void) A_CancelTimer:(dispatch_source_t)timer{
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

@end
