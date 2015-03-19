//
//  A_Animation.m
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import "A_Animation.h"
#import <UIKit/UIKit.h>

#import "A_DeviceHelper.h"

@implementation A_Animation

#pragma mark - Creating Animation
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
+ (CABasicAnimation*) A_MoveToPosition:(CGPoint)destination Duration:(double)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = 0.0f;
    animation.duration = duration;
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


#pragma mark - Transition Creator
+ (CATransition*) A_CreateSystemTransition:(A_Animation_SystemTransitionType)transitionType Direction:(A_Animation_DirectionType)directionType Duration:(float)duration {

    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.duration = duration;
    
    switch (transitionType) {
        case A_Animation_SystemTransition_Reveal:
            transition.type = kCATransitionReveal;
            break;
        case A_Animation_SystemTransition_MoveIn:
            transition.type = kCATransitionMoveIn;
            break;
        case A_Animation_SystemTransition_Push:
            transition.type = kCATransitionPush;
            break;
        case A_Animation_SystemTransition_Fade:
            transition.type = kCATransitionFade;
            break;
        default:
            transition.type = kCATransitionFade;
            NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Create System Transition> \r\n Unkonw Transition Type");
            break;
    }
    
    switch (directionType) {
        case A_Animation_Direction_Top:
            transition.subtype = kCATransitionFromTop;
            break;
        case A_Animation_Direction_Right:
            transition.subtype = kCATransitionFromRight;
            break;
        case A_Animation_Direction_Bottom:
            transition.subtype = kCATransitionFromBottom;
            break;
        case A_Animation_Direction_Left:
            transition.subtype = kCATransitionFromLeft;
            break;
        default:
            transition.subtype = kCATransitionFromBottom;
            NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Create System Transition> \r\n Unkonw Direction Type");
            break;
    }
    
    return transition;
}

#pragma mark - Executing Animation
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations {
    [UIView animateWithDuration:duration animations:animations];
}
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations WhenCompleted:(void (^)(BOOL finished))block  {
    [UIView animateWithDuration:duration animations:animations completion:block];
}
+ (void) A_SubmitTransaction: (CALayer*)layer Animations:(NSDictionary*)animations WhenCompleted:(void (^)(void))block {
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        for (NSString* key in animations) {
            CABasicAnimation* animationItem = [animations objectForKey:key];
            [layer addAnimation:animationItem forKey:key];
        }
    } [CATransaction commit];
}


+ (void) A_CardIn:(CALayer*)layer Direction:(A_Animation_DirectionType)direction Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block{
    
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DScale(t, 0.85, 0.85, 1);
    layer.transform = t;
    
    CGPoint _originalPoint = layer.position;
    CGRect _origeinalFrame = layer.frame;
    
    switch (direction) {
        case A_Animation_Direction_Top:
            layer.position = [A_Animation A_MakeLayerPosition:layer PositionX:layer.frame.origin.x Y:layer.frame.size.height*-1];
            break;
        case A_Animation_Direction_Left:
            layer.position = [A_Animation A_MakeLayerPosition:layer PositionX:layer.frame.size.width*-1 Y:layer.frame.origin.y];
            break;
        case A_Animation_Direction_Bottom:
            layer.position = [A_Animation A_MakeLayerPosition:layer PositionX:layer.frame.origin.x Y:[A_DeviceHelper A_DeviceHeight]];
            break;
        case A_Animation_Direction_Right:
            layer.position = [A_Animation A_MakeLayerPosition:layer PositionX:[A_DeviceHelper A_DeviceWidth] Y:layer.frame.origin.y];
            break;
        default:
            break;
    }
    
    [layer setHidden:NO];
    
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:(duration*0.2) animations:^{
            layer.position = _originalPoint;
        }];
        [UIView addKeyframeWithRelativeStartTime:(duration*0.8) relativeDuration:(duration*0.2) animations:^{
            layer.transform = CATransform3DIdentity;
        }];
    } completion:block];
}
+ (void) A_CardOut:(CALayer*)layer Direction:(A_Animation_DirectionType)direction Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block{
    
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DScale(t, 0.85, 0.85, 1);
    
    CGPoint _position;
    switch (direction) {
        case A_Animation_Direction_Top:
            _position = [A_Animation A_MakeLayerPosition:layer PositionX:layer.frame.origin.x Y:layer.frame.size.height*-1];
            break;
        case A_Animation_Direction_Left:
            _position = [A_Animation A_MakeLayerPosition:layer PositionX:layer.frame.size.width*-1 Y:layer.frame.origin.y];
            break;
        case A_Animation_Direction_Bottom:
            _position = [A_Animation A_MakeLayerPosition:layer PositionX:layer.frame.origin.x Y:[A_DeviceHelper A_DeviceHeight]];
            break;
        case A_Animation_Direction_Right:
            _position = [A_Animation A_MakeLayerPosition:layer PositionX:[A_DeviceHelper A_DeviceWidth] Y:layer.frame.origin.y];
            break;
        default:
            break;
    }
    
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:(duration*0.2) animations:^{
            layer.transform = t;
        }];
        [UIView addKeyframeWithRelativeStartTime:(duration*0.8) relativeDuration:(duration*0.2) animations:^{
            layer.position = _position;
        }];
    } completion:block];
}

#pragma mark - Calculating helper
+ (CGPoint) A_MakeLayerPosition: (CALayer*)layer PositionX:(float)x Y:(float)y {
    CGPoint _destinationPoint = CGPointMake(x + (layer.frame.size.width * layer.anchorPoint.x), y + (layer.frame.size.height * layer.anchorPoint.y));
    return _destinationPoint;
}


@end




