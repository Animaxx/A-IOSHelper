//
//  CALayer+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/28/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "CALayer+A_Animation.h"

#define defaultDurationTime 0.5f;

@implementation CALayer(A_Animation)

#pragma mark - Animation Provider
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration FPS:(A_AnimationFPS)kps AutoSet:(BOOL)isset{
    
    NSParameterAssert(keypath);
    NSParameterAssert(type);
    NSParameterAssert(end);
    
    if (kps<=0) {
        kps = A_AnimationFPS_middle;
    }
    if (!start) {
        start = [self valueForKeyPath:keypath];
    }
    if (duration<=0) {
        duration = defaultDurationTime;
    }
    
    CAKeyframeAnimation* keyFrames = [A_Animation A_GenerateKeyframe:keypath Type:type Duration:duration FPS:kps Start:start End:end];
    [self addAnimation:keyFrames forKey:nil];
    
    if (type >= 0 && isset) {
        [self setValue:end forKeyPath:keypath];
    }
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration FPS:(A_AnimationFPS)kps {
    [self A_AnimationSet:keypath AnimtionType:type Start:start End:end Duration:duration FPS:kps AutoSet:YES];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration {
    [self A_AnimationSet:keypath AnimtionType:type Start:start End:end Duration:duration FPS:A_AnimationFPS_high AutoSet:YES];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end Duration:(double)duration {
    [self A_AnimationSet:keypath AnimtionType:type Start:nil End:end Duration:duration FPS:A_AnimationFPS_high AutoSet:YES];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end {
    [self A_AnimationSet:keypath AnimtionType:type Start:nil End:end Duration:0 FPS:A_AnimationFPS_high AutoSet:YES];
}

#pragma mark - Animation Layer setting
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html
- (void) A_AnimationSetAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type{
    [self A_AnimationSet:@"anchorPoint" AnimtionType:type Start:nil End:[NSValue valueWithCGPoint:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"backgroundColor" AnimtionType:type Start:nil End:value Duration:0 FPS:A_AnimationFPS_high AutoSet:NO];
    self.backgroundColor = value.CGColor;
}
- (void) A_AnimationSetOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"opacity" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetPosition:(CGPoint)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"position" AnimtionType:type Start:nil End:[NSValue valueWithCGPoint:value] Duration:0 FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"borderWidth" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"borderColor" AnimtionType:type Start:nil End:value Duration:0 FPS:A_AnimationFPS_high AutoSet:NO];
    self.borderColor = value.CGColor;
}
- (void) A_AnimationSetContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"contentsRect" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"radius" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowOffset" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetShadowOpacity:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowOpacity" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowRadius" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"sublayerTransform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"zPosition" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}

//https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html

- (void) A_AnimationSetRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.rotation.x" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.rotation.y" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.rotation.z" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale.x" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale.y" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale.z" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScale:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation.x" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation.y" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation.z" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslation:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:0 FPS:A_AnimationFPS_high];
}


@end
