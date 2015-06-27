//
//  UIView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+A_Extension.h"

#define defaultDurationTime 0.5f;

@implementation UIView (A_Extension)


#pragma mark - Animation Provider
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration FPS:(A_AnimationFPS)kps {
    
    NSParameterAssert(keypath);
    NSParameterAssert(type);
    NSParameterAssert(end);
    
    if (kps<=0) {
        kps = A_AnimationFPS_middle;
    }
    if (!start) {
        start = [self.layer valueForKeyPath:keypath];
    }
    if (duration<=0) {
        duration = defaultDurationTime;
    }
    
    CAKeyframeAnimation* keyFrames = [A_Animation A_GenerateKeyframe:keypath Type:type Duration:duration FPS:kps Start:start End:end];
    [self.layer addAnimation:keyFrames forKey:nil];
    if (type >= 0) {
        [self.layer setValue:end forKeyPath:keypath];
    }
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration {
    [self A_AnimationSet:keypath AnimtionType:type Start:start End:end Duration:duration FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end Duration:(double)duration {
    [self A_AnimationSet:keypath AnimtionType:type Start:nil End:end Duration:duration FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end {
    [self A_AnimationSet:keypath AnimtionType:type Start:nil End:end Duration:0 FPS:A_AnimationFPS_middle];
}

#pragma mark - Animation Layer setting
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html




#pragma mark - Animation Effect
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat Duration:(double)duration{
    if (duration <= 0)
        duration = defaultDurationTime;
    
    CAAnimationGroup* animations = [A_Animation A_GenerateEffect:type Duration:duration];
    if (repeat > 0) {
        animations.repeatCount = repeat;
    }
    
    if (type == A_AnimationEffectType_flipInX ||
        type == A_AnimationEffectType_flipInY ||
        type == A_AnimationEffectType_fadeIn ||
        type == A_AnimationEffectType_zoomIn) {
        [self setHidden:NO];
        [self setAlpha:1.0f];
        [self.layer setHidden:NO];
    }
    
    [self.layer addAnimation:animations forKey:nil];
    
    if (type == A_AnimationEffectType_flipOutX ||
        type == A_AnimationEffectType_flipOutY ||
        type == A_AnimationEffectType_fadeOut ||
        type == A_AnimationEffectType_zoomOut) {
        [self.layer setHidden:YES];
    }
    
}
- (void) A_AnimationEffect:(A_AnimationEffectType)type Repeat:(float)repeat{
    [self A_AnimationEffect:type Repeat:repeat Duration:0];
}
- (void) A_AnimationEffect:(A_AnimationEffectType)type{
    [self A_AnimationEffect:type Repeat:0 Duration:0];
}



@end

