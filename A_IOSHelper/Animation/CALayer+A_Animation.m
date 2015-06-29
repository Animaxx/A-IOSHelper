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
    [self A_AnimationSet:keypath AnimtionType:type Start:start End:end Duration:duration FPS:A_AnimationFPS_middle AutoSet:YES];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end Duration:(double)duration {
    [self A_AnimationSet:keypath AnimtionType:type Start:nil End:end Duration:duration FPS:A_AnimationFPS_middle AutoSet:YES];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end {
    [self A_AnimationSet:keypath AnimtionType:type Start:nil End:end Duration:0 FPS:A_AnimationFPS_middle AutoSet:YES];
}

#pragma mark - Animation Layer setting
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html

//backgroundFilters
//contents
//filters
//shadowColor
//mask

- (void) A_AnimationSetAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type{
    [self A_AnimationSet:@"anchorPoint" AnimtionType:type Start:nil End:[NSValue valueWithCGPoint:value] Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"backgroundColor" AnimtionType:type Start:nil End:value Duration:0 FPS:A_AnimationFPS_middle AutoSet:NO];
    self.backgroundColor = value.CGColor;
}
- (void) A_AnimationSetOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"opacity" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_middle];
}

- (void) A_AnimationSetBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"borderWidth" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"borderColor" AnimtionType:type Start:nil End:value Duration:0 FPS:A_AnimationFPS_middle AutoSet:NO];
    self.borderColor = value.CGColor;
}
- (void) A_AnimationSetContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"contentsRect" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:value] Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"radius" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_middle];
}

- (void) A_AnimationSetShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowOffset" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetShadowOpacity:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowOpacity" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowRadius" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"sublayerTransform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:0 FPS:A_AnimationFPS_middle];
}
- (void) A_AnimationSetZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"zPosition" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_middle];
}


@end
