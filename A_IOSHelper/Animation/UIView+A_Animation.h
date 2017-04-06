//
//  UIView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A_Animation.h"

@class A_ChainAnimation;

@interface UIView (A_Animation)

#pragma mark - Animation Effect Express
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat Duration:(double)duration CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat Duration:(double)duration;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat;

- (void) A_AnimationEffect:(A_AnimationEffectType)type Duration:(double)duration CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Duration:(double)duration;

- (void) A_AnimationEffect:(A_AnimationEffectType)type CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type;


#pragma mark - Simple Chian Animation
- (A_ChainAnimation *)addAnimateWithDuration:(NSTimeInterval)duration
                                   aniamtion:(void(^)(void))animationBlock;

- (A_ChainAnimation *)addAnimateWithDuration:(NSTimeInterval)duration
                                   aniamtion:(void(^)(void))animationBlock
                                  completion:(void(^)(void))completionBlock;

- (A_ChainAnimation *)addAnimateWithWaitTime:(NSTimeInterval)waitTime
                                    duration:(NSTimeInterval)duration
                                   aniamtion:(void(^)(void))animationBlock;

- (A_ChainAnimation *)addAnimateWithWaitTime:(NSTimeInterval)waitTime
                                    duration:(NSTimeInterval)duration
                                   aniamtion:(void(^)(void))animationBlock
                                  completion:(void(^)(void))completionBlock;

#pragma mark - Create Chain Aniamtion;
- (A_ChainAnimation *)syncAnimate;
- (A_ChainAnimation *)animate;
- (A_ChainAnimation *)animateWait:(NSTimeInterval)waitTime;

#pragma mark - Chain Effect Animation
- (A_ChainAnimation *)addAnimateWithEffect:(A_AnimationEffectType)effect type:(A_AnimationType)type duration:(NSTimeInterval)duration;


@end
