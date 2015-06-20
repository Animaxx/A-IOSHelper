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
+ (CAAnimation*) A_FadeIn:(double)duration {
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
+ (CAAnimation*) A_FadeOut:(double)duration {
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
+ (CAAnimation*) A_MoveTo:(double)duration OriginalPosition:(CGPoint)oiginalPosition Destination:(CGPoint)destination {
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
+ (CAAnimation*) A_MoveToPosition:(CGPoint)destination Duration:(double)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = 0.0f;
    animation.duration = duration;
    animation.toValue = [NSValue valueWithCGPoint:destination];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBoth;
    animation.additive = NO;
    return animation;
}

+ (CAAnimation*) A_ChangeSize:(double)duration OriginalSize:(CGRect)oiginalBounds To:(CGSize)size {
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
+ (CAAnimation*) A_ChangeShapeToBall: (double)duration OriginalRadius:(CGFloat)originalradius To: (CGFloat)radius {
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
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Create System Transition> \r\n Unkonw Transition Type \r\n -------- \r\n\r\n");
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
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Create System Transition> \r\n Unkonw Direction Type \r\n -------- \r\n\r\n");
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

#pragma mark - Keyframe animation
typedef double(^keyframeCalculatingBlock)(double t, double b, double c, double d);

+(keyframeCalculatingBlock) _methodProvider:(A_AnimationType)type {
    keyframeCalculatingBlock _calculatingBlock;
    switch (type) {
            //http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
            //http://easings.net/
            
            // Quint
        case A_AnimationType_easeInQuint:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c*(t/=d)*t*t*t + b;
            };
            break;
        case A_AnimationType_easeOutQuint:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c*((t=t/d-1)*t*t*t*t + 1) + b;
            };
            break;
        case A_AnimationType_easeInOutQuint:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
                return c/2*((t-=2)*t*t*t*t + 2) + b;
            };
            break;
            //Circ
        case A_AnimationType_easeInCirc:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return -c * (sqrt(1 - (t/=d)*t) - 1) + b;
            };
            break;
        case A_AnimationType_easeOutCirc:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c * sqrt(1 - (t=t/d-1)*t) + b;
            };
            break;
        case A_AnimationType_easeInOutCirc:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                if ((t/=d/2) < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
                return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b;
            };
            break;
            //Back
        case A_AnimationType_easeInBack:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                const double s = 1.70158;
                return c*(t/=d)*t*((s+1)*t - s) + b;
            };
            break;
        case A_AnimationType_easeOutBack:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                const double s = 1.70158;
                return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
            };
            break;
        case A_AnimationType_easeInOutBack:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double s = 1.70158;
                if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
                return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
            };
            break;
            
            //Elastic
        case A_AnimationType_easeInElastic:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double s = 1.70158; double p=0; double a=c;
                
                if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
                if (a < fabs(c)) { a=c; s=p/4; }
                else s = p/(2*M_PI) * asin (c/a);
                return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
            };
            break;
        case A_AnimationType_easeOutElastic:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double s=1.70158, p=0, a=c;
                if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
                if (a < fabs(c)) { a=c; s=p/4; }
                else s = p/(2*M_PI) * asin (c/a);
                return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b;
            };
            break;
        case A_AnimationType_easeInOutElastic:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double s=1.70158, p=0, a=c;
                if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
                if (a < fabs(c)) { a=c; s=p/4; }
                else s = p/(2*M_PI) * asin(c/a);
                if (t < 1) return -.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
                return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
            };
            break;
            //Bounce
        case A_AnimationType_easeInBounce:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double _v;
                t = d-t;
                if ((t/=d) < (1/2.75)) {
                    _v = c*(7.5625*t*t);
                } else if (t < (2/2.75)) {
                    _v = c*(7.5625*(t-=(1.5/2.75))*t + .75);
                } else if (t < (2.5/2.75)) {
                    _v = c*(7.5625*(t-=(2.25/2.75))*t + .9375);
                } else {
                    _v = c*(7.5625*(t-=(2.625/2.75))*t + .984375);
                }
                return c - _v + b;
            };
            break;
        case A_AnimationType_easeOutBounce:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                if ((t/=d) < (1/2.75)) {
                    return c*(7.5625*t*t) + b;
                } else if (t < (2/2.75)) {
                    return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
                } else if (t < (2.5/2.75)) {
                    return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
                } else {
                    return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
                }
            };
            break;
        case A_AnimationType_easeInOutBounce:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                
                double _v;
                if (t < d/2) {
                    //                    return NSBKeyframeAnimationFunctionEaseInBounce (t*2, 0, c, d) * .5 + b;
                    t=t*2;
                    if ((t/=d) < (1/2.75)) {
                        _v = c*(7.5625*t*t);
                    } else if (t < (2/2.75)) {
                        _v = c*(7.5625*(t-=(1.5/2.75))*t + .75);
                    } else if (t < (2.5/2.75)) {
                        _v = c*(7.5625*(t-=(2.25/2.75))*t + .9375);
                    } else {
                        _v = c*(7.5625*(t-=(2.625/2.75))*t + .984375);
                    }
                    return _v * .5 + b;
                } else {
                    //                    return NSBKeyframeAnimationFunctionEaseOutBounce(t*2-d, 0, c, d) * .5 + c*.5 + b;
                    t=t*2-d;
                    if ((t/=d) < (1/2.75)) {
                        _v = c*(7.5625*t*t);
                    } else if (t < (2/2.75)) {
                        _v = c*(7.5625*(t-=(1.5/2.75))*t + .75);
                    } else if (t < (2.5/2.75)) {
                        _v = c*(7.5625*(t-=(2.25/2.75))*t + .9375);
                    } else {
                        _v = c*(7.5625*(t-=(2.625/2.75))*t + .984375);
                    }
                    return _v * .5 + c*.5 + b;
                }
            };
            break;
            
            // http://khanlou.com/2012/01/cakeyframeanimation-make-it-bounce/
        case A_AnimationType_spring:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double a = log2f(3.0f/fabs(b-c))/d;
                if (a>0) a = -1.0f*a;
                return (b-c)*pow(2.71, a*t)*cos(6.0*M_PI/d*t)+c;
            };
            break;
            
        default:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return ((c-b)/d)*t;
            };
            break;
    }
    return _calculatingBlock;
}

+(NSArray*)_getFloatValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGFloat)start End:(CGFloat)end {
    
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    for (int i=0; i<steps; i++) {
        CGFloat _v = (CGFloat)_calculatingBlock((double)i, (double)start, (double)end, (double)steps);
        [_values addObject:@(_v)];
    }
    
    return _values;
}
+(NSArray*)_getPointValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGPoint)start End:(CGPoint)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    for (int i=0; i<steps; i++) {
        CGPoint point = {
            .x = _calculatingBlock((double)i, (double)start.x, (double)end.x, (double)steps),
            .y = _calculatingBlock((double)i, (double)start.y, (double)end.y, (double)steps),
        };
        [_values addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return _values;
}
+(NSArray*)_getSizeValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGSize)start End:(CGSize)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    for (int i=0; i<steps; i++) {
        CGSize size = {
            .width = _calculatingBlock((double)i, (double)start.width, (double)end.width, (double)steps),
            .height = _calculatingBlock((double)i, (double)start.height, (double)end.height, (double)steps),
        };
        [_values addObject:[NSValue valueWithCGSize:size]];
    }
    
    return _values;
}
+(NSArray*)_getRectValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGRect)start End:(CGRect)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    for (int i=0; i<steps; i++) {
        CGRect rect = {
            .origin.x = _calculatingBlock((double)i, (double)start.origin.x, (double)end.origin.x, (double)steps),
            .origin.y = _calculatingBlock((double)i, (double)start.origin.y, (double)end.origin.y, (double)steps),
            .size.width = _calculatingBlock((double)i, (double)start.size.width, (double)end.size.width, (double)steps),
            .size.height = _calculatingBlock((double)i, (double)start.size.height, (double)end.size.height, (double)steps),
            
        };
        [_values addObject:[NSValue valueWithCGRect:rect]];
    }
    
    return _values;
}
+(NSArray*)_getCATransform3DValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CATransform3D)start End:(CATransform3D)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    for (int i=0; i<steps; i++) {
        CATransform3D transform3d = {
            .m11 = _calculatingBlock((double)i, (double)start.m11, (double)end.m11, (double)steps),
            .m12 = _calculatingBlock((double)i, (double)start.m12, (double)end.m12, (double)steps),
            .m13 = _calculatingBlock((double)i, (double)start.m13, (double)end.m13, (double)steps),
            .m14 = _calculatingBlock((double)i, (double)start.m14, (double)end.m14, (double)steps),
            .m21 = _calculatingBlock((double)i, (double)start.m21, (double)end.m21, (double)steps),
            .m22 = _calculatingBlock((double)i, (double)start.m22, (double)end.m22, (double)steps),
            .m23 = _calculatingBlock((double)i, (double)start.m23, (double)end.m23, (double)steps),
            .m24 = _calculatingBlock((double)i, (double)start.m24, (double)end.m24, (double)steps),
            .m31 = _calculatingBlock((double)i, (double)start.m31, (double)end.m31, (double)steps),
            .m32 = _calculatingBlock((double)i, (double)start.m32, (double)end.m32, (double)steps),
            .m33 = _calculatingBlock((double)i, (double)start.m33, (double)end.m33, (double)steps),
            .m34 = _calculatingBlock((double)i, (double)start.m34, (double)end.m34, (double)steps),
            .m41 = _calculatingBlock((double)i, (double)start.m41, (double)end.m41, (double)steps),
            .m42 = _calculatingBlock((double)i, (double)start.m42, (double)end.m42, (double)steps),
            .m43 = _calculatingBlock((double)i, (double)start.m43, (double)end.m43, (double)steps),
            .m44 = _calculatingBlock((double)i, (double)start.m44, (double)end.m44, (double)steps),
        };
        [_values addObject:[NSValue valueWithCATransform3D:transform3d]];
    }
    
    return _values;
}

+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_Animation_kFPS)kpfs Start:(id)start End:(id)end {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keypath];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    NSInteger steps = duration*kpfs;
    
    if ([start isKindOfClass:NSNumber.class] && [end isKindOfClass:NSNumber.class]) {
        animation.values = [self _getFloatValues:type Steps:steps Start:[start doubleValue] End:[end doubleValue]];
    } else if (([start isKindOfClass:NSValue.class] && [end isKindOfClass:NSValue.class]) && strcmp([start objCType], [end objCType]) == 0) {
        if (strcmp([start objCType], @encode(CATransform3D)) == 0) {
            animation.values = [self _getCATransform3DValues:type Steps:steps Start:[start CATransform3DValue] End:[end CATransform3DValue]];
        }
        if (strcmp([start objCType], @encode(CGRect)) == 0) {
            animation.values = [self _getRectValues:type Steps:steps Start:[start CGRectValue] End:[end CGRectValue]];
        }
        if (strcmp([start objCType], @encode(CGPoint)) == 0) {
            animation.values = [self _getPointValues:type Steps:steps Start:[start CGPointValue] End:[end CGPointValue]];
        }
        if (strcmp([start objCType], @encode(CGSize)) == 0) {
            animation.values = [self _getSizeValues:type Steps:steps Start:[start CGSizeValue] End:[end CGSizeValue]];
        }
    }
    
    
    return animation;
}


@end




