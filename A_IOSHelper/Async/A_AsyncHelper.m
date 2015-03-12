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

+ (void) A_DelayExecute: (double) delaySec Method: (dispatch_block_t) method {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), method);
}

@end
