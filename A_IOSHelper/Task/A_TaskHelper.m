//
//  A_TaskHelper.m
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_TaskHelper.h"


@implementation A_TaskHelper {
    NSMutableArray *_tasks;
    NSMutableDictionary *_params;
}

static const char *threadQueueLabel = "com.Animax.iOSHelperQueue";

+ (void) A_RunInBackground: (dispatch_block_t)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
+ (void) A_RunInBackground: (id (^)(void))block WhenDone: (void (^)(id arg))finishBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        id result = block();
        dispatch_async(dispatch_get_main_queue(), ^{
            finishBlock(result);
        });
    });
}

+ (void) A_RunInBackgroundWithParam:(id)param Block:(void (^)(id arg))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        block(param);
    });
}
+ (void) A_RunInBackgroundWithParam:(id)param Block:(id (^)(id arg))block WhenDone:(void (^)(id arg, id result))finishBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        id result = block(param);
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            finishBlock(param,result);
        });
    });
}

+ (void) A_RunInMain:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
+ (void) A_RunInMainWithParam:(id)param Block:(void (^)(id arg))block{
    if ([NSThread isMainThread]) {
        block(param);
    }  else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(param);
        });
    }
}

+ (void) A_Delay:(double)delaySec RunInMain:(dispatch_block_t)method{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), method);
}
+ (void) A_Delay:(double)delaySec Param:(id)param RunInMain:(void (^)(id arg))method{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        method(param);
    });
}

+ (dispatch_source_t) A_StartTimer:(double)seconds Block:(dispatch_block_t) block {
    return [self A_StartTimer:seconds Block:block InMain:YES];
}
+ (dispatch_source_t) A_StartTimer:(double)seconds Block:(dispatch_block_t) block InMain:(bool)inMain {
    dispatch_queue_t queue;
    if (inMain) {
        queue = dispatch_get_main_queue();
    } else {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), seconds * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
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

#pragma mark - Task chain
+ (A_TaskHelper*) A_Init {
    return [[A_TaskHelper alloc] init];
}
+ (A_TaskHelper*) A_Init: (A_Task_RunningEnvironment)environment Sequential:(bool)sequential {
    A_TaskHelper *task = [[A_TaskHelper alloc] init];
    [task setSequential:sequential];
    [task setRunningEnvironment:environment];
    return task;
}

- (id) init {
    if ((self = [super init])) {
        [self setRunningEnvironment:A_Task_RunInBackgroupCompleteInMain];
        [self setSequential:YES];
        _params = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (A_TaskHelper*) A_AddTask:(TaskBlock) block {
    @synchronized(self) {
        if (!_tasks) {
            _tasks = [[NSMutableArray alloc] init];
        }
        
        if (block) {
            [_tasks addObject:block];
        }
        return self;
    }
}
- (A_TaskHelper*) A_AddDelayTask:(float)seconds {
    @synchronized(self) {
        TaskBlock _block = ^(A_TaskHelper *task) {
            [NSThread sleepForTimeInterval:seconds];
        };
        [self A_AddTask:_block];
        return self;
    }
}
- (A_TaskHelper*) A_AddDelayTask:(float)seconds Block:(TaskBlock) block {
    @synchronized(self) {
        TaskBlock _block = ^(A_TaskHelper *task) {
            [NSThread sleepForTimeInterval:seconds];
            block(task);
        };
        [self A_AddTask:_block];
        return self;
    }
}

- (void) A_Set:(NSString*)name Value:(id)value{
    @synchronized(self) {
        [_params setObject:value forKey:name];
    }
}
- (id) A_Get:(NSString*)name{
    if (_params) {
        return [_params objectForKey:name];
    } else {
        return nil;
    }
}

- (void) A_Execute {
    [self A_ExecuteWithCompletion:nil];
}
- (void) A_ExecuteWithCompletion:(TaskBlock)block {
    @autoreleasepool {
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue;
        
        if (self.runningEnvironment == A_Task_RunInBackgroup || self.runningEnvironment == A_Task_RunInBackgroupCompleteInMain) {
            if (self.sequential) {
                queue = dispatch_queue_create(threadQueueLabel, DISPATCH_QUEUE_SERIAL);
            } else {
                queue = dispatch_queue_create(threadQueueLabel, DISPATCH_QUEUE_CONCURRENT);
            }
        } else {
            queue = dispatch_get_main_queue();
        }
        
        for (TaskBlock _block in _tasks) {
            dispatch_group_async(group,queue, ^{
                _block(self);
            });
        }
        
        if (block) {
            dispatch_group_notify(group, queue, ^{
                if (self.runningEnvironment == A_Task_RunInBackgroup || self.runningEnvironment == A_Task_RunInMainCompleteInBackgroup) {
                    dispatch_async(queue, ^{
                        block(self);
                    });
                } else {
                    [A_TaskHelper A_RunInMain:^{
                        block(self);
                    }];
                }
            });
        }
    }
}

- (void)dealloc {
    [self setTag:nil];
    if (_tasks)
        _tasks = nil;
    if (_params)
        _params = nil;
}

@end


