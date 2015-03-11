//
//  A_AsyncHelper.h
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_AsyncHelper : NSObject

+ (void) A_RunInBackground: (dispatch_block_t)block;
+ (void) A_RunInBackground: (dispatch_block_t) block WhenDone: (dispatch_block_t) finishBlock;
+ (void) A_DelayExecute: (double)delaySec Method: (dispatch_block_t)method;

@end
