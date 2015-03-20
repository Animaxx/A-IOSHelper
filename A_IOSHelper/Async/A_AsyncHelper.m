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

@end
