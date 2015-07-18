//
//  UIView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+A_Animation.h"

#define defaultDurationTime 0.5f;

@implementation UIView (A_Animation)


#pragma mark - Animation Effect
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat Duration:(double)duration CompletionBlock:(void (^)(void))block{
    if (duration <= 0)
        duration = defaultDurationTime;
    
    if (type == A_AnimationEffectType_flipInX ||
        type == A_AnimationEffectType_flipInY ||
        type == A_AnimationEffectType_fadeIn ||
        type == A_AnimationEffectType_zoomIn ||
        type == A_AnimationEffectType_cardIn) {
        [self setHidden:NO];
        [self setAlpha:1.0f];
        [self.layer setHidden:NO];
    }
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            if (type == A_AnimationEffectType_flipOutX ||
                type == A_AnimationEffectType_flipOutY ||
                type == A_AnimationEffectType_fadeOut ||
                type == A_AnimationEffectType_zoomOut ||
                type == A_AnimationEffectType_cardOut) {
                [self.layer setHidden:YES];
            }
            if (block) {
                block();
            }
        }];
    
        CAAnimationGroup *animations = [A_Animation A_GenerateEffect:type Duration:duration];
        if (repeat > 0) {
            animations.repeatCount = repeat;
        }
        
        [self.layer addAnimation:animations forKey:nil];
    
    } [CATransaction commit];
}
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat Duration:(double)duration{
    [self A_AnimationEffect:type Repeat:repeat Duration:duration CompletionBlock:nil];
}
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat CompletionBlock:(void (^)(void))block {
    [self A_AnimationEffect:type Repeat:repeat Duration:0 CompletionBlock:block];
}
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat{
    [self A_AnimationEffect:type Repeat:repeat Duration:0 CompletionBlock:nil];
}

- (void) A_AnimationEffect:(A_AnimationEffectType)type Duration:(double)duration CompletionBlock:(void (^)(void))block{
    [self A_AnimationEffect:type Repeat:0 Duration:duration CompletionBlock:block];
}
- (void) A_AnimationEffect:(A_AnimationEffectType)type Duration:(double)duration{
    [self A_AnimationEffect:type Repeat:0 Duration:duration CompletionBlock:nil];
}

- (void) A_AnimationEffect:(A_AnimationEffectType)type CompletionBlock:(void (^)(void))block {
    [self A_AnimationEffect:type Repeat:0 Duration:0 CompletionBlock:block];
}
- (void) A_AnimationEffect:(A_AnimationEffectType)type{
    [self A_AnimationEffect:type Repeat:0 Duration:0 CompletionBlock:nil];
}

@end

