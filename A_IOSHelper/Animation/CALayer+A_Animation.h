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

#pragma mark - Animation Layer Setting
- (void) A_AnimationSetAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetPosition:(CGPoint)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetPositionX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetPositionY:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetBounds:(CGRect)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetShadowOpacity:(CGSize)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetSize:(CGSize)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetTransformScaleX:(CGFloat)x Y:(CGFloat)y AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetTransformScaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z AnimtionType:(A_AnimationType)type;


#pragma mark - Animation Transform Setting
- (void) A_AnimationSetRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetScale:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationSetTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (void) A_AnimationSetTranslation:(CGSize)value AnimtionType:(A_AnimationType)type;

#pragma mark - Custom Setting
/* Range of value [0 ... 1.0], 0 means no change */
- (void) A_AnimationCustomLeftOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;
/* Range of value [0 ... 1.0], 0 means no change */
- (void) A_AnimationCustomRightOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;
/* Range of value [0 ... 1.0], 0 means no change */
- (void) A_AnimationCustomTopOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;
/* Range of value [0 ... 1.0], 0 means no change */
- (void) A_AnimationCustomBottomOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;

- (void) A_AnimationCustomRecoverOblique:(A_AnimationType)type;

@end

