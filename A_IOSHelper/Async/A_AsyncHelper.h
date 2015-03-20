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

+ (void) A_RunInBackgroundWithObj:(id) obj Block:(void (^)(id arg))block;
+ (void) A_RunInBackgroundWithObj:(id) obj Block:(id (^)(id arg))block WhenDone:(void (^)(id arg, id result))finishBlock;

+ (void) A_DelayExecute:(dispatch_block_t) method Delay:(double) delaySec;
+ (void) A_DelayExecuteWithObj:(id)obj Method: (void (^)(id arg))method Delay:(double) delaySec;

@end
