//
//  A_Animation.m
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import "A_Animation.h"
#import <UIKit/UIKit.h>

@implementation A_Animation

+ (CABasicAnimation*) A_FadeIn:(double)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.beginTime = 0.0f;
    animation.duration = duration;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    return animation;
}
+ (CABasicAnimation*) A_FadeOut:(double)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.beginTime = 0.0f;
    animation.duration = duration;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    return animation;
}

+ (CABasicAnimation*) A_MoveTo:(double)duration OriginalPosition:(CGPoint)oiginalPosition Destination:(CGPoint)destination {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = 0.0f;
    animation.duration = duration;
    animation.fromValue = [NSValue valueWithCGPoint:oiginalPosition];
    animation.toValue = [NSValue valueWithCGPoint:destination];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    return animation;
}
+ (CABasicAnimation*) A_ChangeSize:(double)duration OriginalSize:(CGRect)oiginalBounds To:(CGSize)size {
    CGRect newBounds = oiginalBounds;
    newBounds.size = size;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.beginTime = 0.0f;
    animation.duration = duration;
    animation.fromValue = [NSValue valueWithCGRect:oiginalBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    return animation;
}

+ (CABasicAnimation*) A_ChangeShapeToBall: (double)duration OriginalRadius:(CGFloat)originalradius To: (CGFloat)radius {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = duration;
    animation.fromValue = [NSNumber numberWithFloat:originalradius];
    animation.toValue = [NSNumber numberWithFloat:radius];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    return animation;
}

+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations {
    [UIView animateWithDuration:duration animations:animations];
}
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations WhenCompleted:(void (^)(BOOL finished))block  {
    [UIView animateWithDuration:duration animations:animations completion:block];
}



@end




