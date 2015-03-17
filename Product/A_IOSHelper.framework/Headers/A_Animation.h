//
//  A_Animation.h
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface A_Animation : NSObject

#pragma mark - Creating Animation
+ (CABasicAnimation*) A_FadeIn:(double)duration;
+ (CABasicAnimation*) A_FadeOut:(double)duration;

+ (CABasicAnimation*) A_MoveTo:(double)duration OriginalPosition:(CGPoint)oiginalPosition Destination:(CGPoint)destination;
+ (CABasicAnimation*) A_MoveToPosition:(CGPoint)destination Duration:(double)duration;

+ (CABasicAnimation*) A_ChangeSize:(double)duration OriginalSize:(CGRect)oiginalBounds To:(CGSize)size;
+ (CABasicAnimation*) A_ChangeShapeToBall: (double)duration OriginalRadius:(CGFloat)originalradius To: (CGFloat)radius;

#pragma mark - Cxecuting Animation
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations;
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations WhenCompleted:(void (^)(BOOL finished))block;
+ (void) A_SubmitTransaction: (CALayer*)layer Animations:(NSDictionary*)animations WhenCompleted:(void (^)(void))block;

#pragma mark - Calculating helper
+ (CGPoint) A_MakeLayerPosition: (CALayer*)layer PositionX:(float)x Y:(float)y;

@end
