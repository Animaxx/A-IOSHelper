//
//  A_Animation.m
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import "A_Animation.h"
#import <UIKit/UIKit.h>
#import "A_AnimationKeyframeProvider.h"

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

@implementation A_Animation

+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_AnimationFPS)kpfs Start:(id)start End:(id)end {
    return [A_AnimationKeyframeProvider A_GenerateKeyframe:keypath Type:type Duration:duration FPS:kpfs Start:start End:end];
}

+(CAAnimationGroup*)A_GenerateEffect:(A_AnimationEffectType)type Duration:(double)duration {
    
    if (duration<=0) duration = 0.5f;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    [group setRemovedOnCompletion: YES];
    group.duration = duration;
    
    CABasicAnimation *a1,*a2;//,*a3;
    CAKeyframeAnimation *k1,*k2;//,*k3;
    
    switch (type) {
        case A_AnimationEffectType_flash:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.5 :0.5 :1 :1];
            k1.values = @[@(0.2),@(0.8),@(0.2),@(1.0)];
             group.animations = @[k1];
            break;
        case A_AnimationEffectType_pulse:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.5 :0.5 :1 :1];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.05, 1.05, 1.05)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 0.95)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.05, 1.05, 1.05)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 0.95)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_shakeHorizontal:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
            k1.values = @[[NSValue valueWithCGPoint:CGPointMake(0.4, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.6, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.4, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.6, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.4, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_shakeVertical:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
            k1.values = @[[NSValue valueWithCGPoint:CGPointMake(0.5, 0.4)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.6)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.4)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.6)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.4)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_swing:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(15), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-12), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(7), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-7), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 0, 1)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_quake:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-12), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(8),0,0,1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-8),0,0,1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(3),0,0,1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-3),0,0,1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0),0,0,1)]];
            
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_squeeze:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
            k1.values = @[@(1.0), @(1.4), @(0.8), @(1.4), @(1)];
            k2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
            k2.values = @[@(1.0), @(0.6), @(1.4), @(0.6), @(1)];
            
            group.animations = @[k1, k2];
            break;
        case A_AnimationEffectType_wobble:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(RADIANS_TO_DEGREES(-0.5),0,0), DEGREES_TO_RADIANS(-10), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(RADIANS_TO_DEGREES(0.8),0,0), DEGREES_TO_RADIANS(8), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(RADIANS_TO_DEGREES(-1),0,0), DEGREES_TO_RADIANS(-8), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(RADIANS_TO_DEGREES(1),0,0), DEGREES_TO_RADIANS(3), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(RADIANS_TO_DEGREES(-1),0,0), DEGREES_TO_RADIANS(-3), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(RADIANS_TO_DEGREES(0),0,0), DEGREES_TO_RADIANS(0), 0, 0, 1)]];
            
            group.animations = @[k1];
            
            break;
        case A_AnimationEffectType_flipX:
            k1 = [self A_GenerateKeyframe:@"transform" Type:A_AnimationType_easeInOutQuint Duration:duration FPS:A_AnimationFPS_middle Start:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 1, 0, 0)] End:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 1, 0, 0)]];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_flipY:
            k1 = [self A_GenerateKeyframe:@"transform" Type:A_AnimationType_easeInOutQuint Duration:duration FPS:A_AnimationFPS_middle Start:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 1, 0)] End:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 0, 1, 0)]];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_flipLeft:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            k1.values = @[@(0), @(-M_PI / 2), @(-M_PI), @(-M_PI * 1.5), @(-M_PI * 2)];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1.2];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_flipRight:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            k1.values = @[@(0), @(M_PI / 2), @(M_PI), @(M_PI * 1.5), @(M_PI * 2)];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1.2];
            group.animations = @[k1];
            break;
            
            
        case A_AnimationEffectType_flipInX:
            k1 = [self A_GenerateKeyframe:@"transform" Type:A_AnimationType_easeInOutQuint Duration:duration FPS:A_AnimationFPS_middle Start:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 1, 0, 0)] End:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 1, 0, 0)]];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1];
            
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(0.0f);
            a1.toValue = @(1.0f);
            
            group.animations = @[k1,a1];
            break;
        case A_AnimationEffectType_flipInY:
            k1 = [self A_GenerateKeyframe:@"transform" Type:A_AnimationType_easeInOutQuint Duration:duration FPS:A_AnimationFPS_middle Start:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 1, 0)] End:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 0, 1, 0)]];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1];
            group.animations = @[k1];
            
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(0.0f);
            a1.toValue = @(1.0f);
            
            group.animations = @[k1,a1];
            break;
        case A_AnimationEffectType_fadeIn:
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(0.0f);
            a1.toValue = @(1.0f);
            
            group.animations = @[a1];
            break;
        case A_AnimationEffectType_zoomIn:
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(0.0f);
            a1.toValue = @(1.0f);
            
            a2 = [CABasicAnimation animationWithKeyPath:@"transform"];
            a2.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :1.5 :1 :1];
            a2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1)];
            a2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];
            
            group.animations = @[a1,a2];
            break;
            
        case A_AnimationEffectType_flipOutX:
            k1 = [self A_GenerateKeyframe:@"transform" Type:A_AnimationType_easeInOutQuint Duration:duration FPS:A_AnimationFPS_middle Start:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 1, 0, 0)] End:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 1, 0, 0)]];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1];
            
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(1.0f);
            a1.toValue = @(0.0f);
            
            group.animations = @[k1,a1];
            break;
        case A_AnimationEffectType_flipOutY:
            k1 = [self A_GenerateKeyframe:@"transform" Type:A_AnimationType_easeInOutQuint Duration:duration FPS:A_AnimationFPS_middle Start:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 1, 0)] End:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(180), 0, 1, 0)]];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :.5 :1 :1];
            
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(1.0f);
            a1.toValue = @(0.0f);
            
            group.animations = @[k1,a1];
            break;
        case A_AnimationEffectType_fadeOut:
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(1.0f);
            a1.toValue = @(0.0f);
            
            group.animations = @[a1];
            break;
        case A_AnimationEffectType_zoomOut:
            a1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
            a1.fromValue = @(1.0f);
            a1.toValue = @(0.0f);
            
            a2 = [CABasicAnimation animationWithKeyPath:@"transform"];
            a2.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:.5 :1.5 :1 :1];
            a2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];
            a2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1)];
            
            group.animations = @[a1,a2];
            break;

            
        default:
            break;
    }
    
    
    
    return group;
}

@end




