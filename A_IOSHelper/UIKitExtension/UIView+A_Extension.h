//
//  UIView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A_Animation.h"

@interface UIView (A_Extension)

#pragma mark - Animation Provider
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration FPS:(A_AnimationFPS)kps;
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration;
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end Duration:(double)duration;
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end;

#pragma mark - Animation Layer setting


#pragma mark - Animation Effect Express
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat Duration:(double)duration CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat Duration:(double)duration;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat;

- (void) A_AnimationEffect:(A_AnimationEffectType)type Duration:(double)duration CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type Duration:(double)duration;

- (void) A_AnimationEffect:(A_AnimationEffectType)type CompletionBlock:(void (^)(void))block;
- (void) A_AnimationEffect:(A_AnimationEffectType)type;

@end
