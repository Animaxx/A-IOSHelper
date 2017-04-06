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
    
    CAKeyframeAnimation *keyFrames = [A_Animation A_GenerateKeyframe:keypath Type:type Duration:duration FPS:kps Start:start End:end];
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

#pragma mark - Setting layer properties
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html
- (void) A_AnimationSetAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type{
    [self A_AnimationSet:@"anchorPoint" AnimtionType:type Start:nil End:[NSValue valueWithCGPoint:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"anchorPoint" AnimtionType:type Start:nil End:[NSValue valueWithCGPoint:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"backgroundColor" AnimtionType:type Start:nil End:value Duration:0 FPS:A_AnimationFPS_high AutoSet:NO];
    self.backgroundColor = value.CGColor;
}
- (void) A_AnimationSetBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"backgroundColor" AnimtionType:type Start:nil End:value Duration:duration FPS:A_AnimationFPS_high AutoSet:NO];
    self.backgroundColor = value.CGColor;
}
- (void) A_AnimationSetOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"opacity" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"opacity" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetPosition:(CGPoint)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"position" AnimtionType:type Start:nil End:[NSValue valueWithCGPoint:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetPosition:(CGPoint)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"position" AnimtionType:type Start:nil End:[NSValue valueWithCGPoint:value] Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetPositionX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"position.x" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetPositionX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"position.x" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetPositionY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"position.y" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetPositionY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"position.y" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetBounds:(CGRect)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"bounds" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetBounds:(CGRect)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"bounds" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:value] Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"borderWidth" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"borderWidth" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"borderColor" AnimtionType:type Start:nil End:value Duration:0 FPS:A_AnimationFPS_high AutoSet:NO];
    self.borderColor = value.CGColor;
}
- (void) A_AnimationSetBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"borderColor" AnimtionType:type Start:nil End:value Duration:duration FPS:A_AnimationFPS_high AutoSet:NO];
    self.borderColor = value.CGColor;
}
- (void) A_AnimationSetContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"contentsRect" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"contentsRect" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:value] Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"cornerRadius" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"cornerRadius" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowOffset" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"shadowOffset" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetShadowOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowOpacity" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetShadowOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"shadowOpacity" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"shadowRadius" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"shadowRadius" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"sublayerTransform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"sublayerTransform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"zPosition" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"zPosition" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetSize:(CGSize)value AnimtionType:(A_AnimationType)type {
    float widthDiff = (value.width - self.bounds.size.width) / 2.0f;
    float hightDiff = (value.height - self.bounds.size.height) / 2.0f;
    
    CGRect rect = CGRectMake(self.bounds.origin.x - widthDiff , self.bounds.origin.y - hightDiff, self.bounds.size.width + widthDiff, self.bounds.size.height + hightDiff);
    
    [self A_AnimationSet:@"bounds" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:rect] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetSize:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    float widthDiff = (value.width - self.bounds.size.width) / 2.0f;
    float hightDiff = (value.height - self.bounds.size.height) / 2.0f;
    
    CGRect rect = CGRectMake(self.bounds.origin.x - widthDiff , self.bounds.origin.y - hightDiff, self.bounds.size.width + widthDiff, self.bounds.size.height + hightDiff);
    
    [self A_AnimationSet:@"bounds" AnimtionType:type Start:nil End:[NSValue valueWithCGRect:rect] Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform" AnimtionType:type Start:nil End:[NSValue valueWithCATransform3D:value] Duration:duration FPS:A_AnimationFPS_high];
}

#pragma mark - Setting transform elements
//https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html

- (void) A_AnimationSetRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.rotation.x" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.rotation.x" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.rotation.y" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.rotation.y" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.rotation.z" AnimtionType:type Start:nil End:@(value*M_PI/180.0) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.rotation.z" AnimtionType:type Start:nil End:@(value*M_PI/180.0) Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale.x" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.scale.x" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale.y" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.scale.y" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale.z" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.scale.z" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScale:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.scale" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetScale:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.scale" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation.x" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.translation.x" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}

- (void) A_AnimationSetTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation.y" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.translation.y" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation.z" AnimtionType:type Start:nil End:@(value) Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.translation.z" AnimtionType:type Start:nil End:@(value) Duration:duration FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslation:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self A_AnimationSet:@"transform.translation" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:0 FPS:A_AnimationFPS_high];
}
- (void) A_AnimationSetTranslation:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self A_AnimationSet:@"transform.translation" AnimtionType:type Start:nil End:[NSValue valueWithCGSize:value] Duration:duration FPS:A_AnimationFPS_high];
}


#pragma mark - Custom setting
- (void) A_AnimationCustomLeftOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    [self setCustomAnchorPoint:CGPointMake(0.0, 0.5)];
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m14 = (value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*-75)*M_PI/180.0, 0.0, 1.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self A_AnimationSetTransform:concatenatedTransformation AnimtionType:type];
}
- (void) A_AnimationCustomRightOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    [self setCustomAnchorPoint:CGPointMake(1.0, 0.5)];
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m14 = -(value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*75)*M_PI/180.0, 0.0, 1.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self A_AnimationSetTransform:concatenatedTransformation AnimtionType:type];
}
- (void) A_AnimationCustomTopOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    [self setCustomAnchorPoint:CGPointMake(0.5, 0.0)];
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m24 = (value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*75)*M_PI/180.0, 1.0, 0.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self A_AnimationSetTransform:concatenatedTransformation AnimtionType:type];
}
- (void) A_AnimationCustomBottomOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    [self setCustomAnchorPoint:CGPointMake(0.5, 1.0)];
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m24 = -(value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*-75)*M_PI/180.0, 1.0, 0.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self A_AnimationSetTransform:concatenatedTransformation AnimtionType:type];
}

- (void) A_AnimationCustomRecoverOblique:(A_AnimationType)type {
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            [self setCustomAnchorPoint:CGPointMake(0.5, 0.5)];
        }];
        [self A_AnimationSetTransform:CATransform3DIdentity AnimtionType:type];
    } [CATransaction commit];
}

#pragma mark - Helping method
- (void)setCustomAnchorPoint:(CGPoint)anchorPoint {
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.anchorPoint.x, self.bounds.size.height * self.anchorPoint.y);
    
    CGPoint position = self.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.position = position;
    self.anchorPoint = anchorPoint;
}


@end
