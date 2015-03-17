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

+ (CABasicAnimation*) A_FadeIn:(double)duration;
+ (CABasicAnimation*) A_FadeOut:(double)duration;
+ (CABasicAnimation*) A_MoveTo:(double)duration OriginalPosition:(CGPoint)oiginalPosition Destination:(CGPoint)destination;
+ (CABasicAnimation*) A_ChangeSize:(double)duration OriginalSize:(CGRect)oiginalBounds To:(CGSize)size;

+ (CABasicAnimation*) A_ChangeShapeToBall: (double)duration OriginalRadius:(CGFloat)originalradius To: (CGFloat)radius;

+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations;
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations WhenCompleted:(void (^)(BOOL finished))block;

@end
