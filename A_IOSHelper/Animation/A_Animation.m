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


@end
