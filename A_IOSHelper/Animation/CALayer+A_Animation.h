//
//  CALayer+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/28/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "A_Animation.h"

@interface CALayer(A_Animation)

#pragma mark - Animation Provider
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration FPS:(A_AnimationFPS)kps;
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Start:(id)start End:(id)end Duration:(double)duration;
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end Duration:(double)duration;
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end;

#pragma mark - Animation Layer setting

- (void) A_AnimationSetAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetShadowOpacity:(CGSize)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetZPosition:(CATransform3D)value AnimtionType:(A_AnimationType)type;

@end
