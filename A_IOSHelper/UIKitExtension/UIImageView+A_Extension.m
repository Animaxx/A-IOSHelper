//
//  UIImageView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/26/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "UIImageView+A_Extension.h"

#import "A_TaskHelper.h"
#import "A_ImageHelper.h"

@implementation UIImageView(A_Extension)

- (void)A_LoadFromUrl:(NSString*)url {
    A_TaskHelper *_task = [A_TaskHelper A_Init:A_Task_RunInBackgroupCompleteInMain Sequential:NO];
    [_task setParam:self];
    [_task A_AddTask:^(A_TaskHelper *task) {
        _task.result = [A_ImageHelper A_ImageDownloadAndCache:url];
    }];
    [_task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        if (task.result) {
            [(UIImageView*)task.param setImage:task.result];
        }
    }];
}
- (void)A_LoadFromUrl:(NSString*)url WithDeaultImage:(NSString*)deaultImage {
    A_TaskHelper *_task = [A_TaskHelper A_Init:A_Task_RunInBackgroupCompleteInMain Sequential:NO];
    [_task setParam:self];
    [_task setTag:deaultImage];
    [_task A_AddTask:^(A_TaskHelper *task) {
        _task.result = [A_ImageHelper A_ImageDownloadAndCache:url DefaultImage:(NSString*)task.tag];
    }];
    [_task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        if (task.result) {
            [(UIImageView*)task.param setImage:task.result];
        }
    }];
}
- (void)A_LoadFromUrl:(NSString*)url WithDeaultImage:(NSString*)deaultImage AndLoadingImage:(NSString*)loadingImage{
    [A_TaskHelper A_RunInMain:^{
        [self setImage:[A_ImageHelper A_ImageByName:loadingImage]];
    }];
    
    A_TaskHelper *_task = [A_TaskHelper A_Init:A_Task_RunInBackgroupCompleteInMain Sequential:NO];
    [_task setParam:self];
    [_task setTag:deaultImage];
    [_task A_AddTask:^(A_TaskHelper *task) {
        _task.result = [A_ImageHelper A_ImageDownloadAndCache:url DefaultImage:(NSString*)task.tag];
    }];
    [_task A_ExecuteWithCompletion:^(A_TaskHelper *task) {
        if (task.result) {
            [(UIImageView*)task.param setImage:task.result];
        }
    }];
}


@end
