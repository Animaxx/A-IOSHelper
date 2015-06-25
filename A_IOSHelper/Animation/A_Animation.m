//
//  A_Animation.m
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import "A_Animation.h"
#import <UIKit/UIKit.h>


#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

@implementation A_Animation

#pragma mark - Keyframe animation
typedef double(^keyframeCalculatingBlock)(double t, double b, double c, double d);

+(keyframeCalculatingBlock) _methodProvider:(A_AnimationType)type {
    keyframeCalculatingBlock _calculatingBlock;
    switch (type) {
            // t: current time, b: begInnIng value, c: change In value, d: duration
            //http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
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
        case A_AnimationType_longSpring:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double a = log2f(3.0f/fabs(b-c))/d;
                if (a>0) a = -1.0f*a;
                return (b-c)*pow(2.71, a*t)*cos(12.0*M_PI/d*t)+c;
            };
            break;
        case A_AnimationType_bigSpring:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double a = log2f(6.0f/fabs(b-c))/d;
                if (a>0) a = -1.0f*a;
                return (b-c)*pow(2.71, a*t)*cos(6.0*M_PI/d*t)+c;
            };
            break;
        case A_AnimationType_bigLongSpring:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double a = log2f(6.0f/fabs(b-c))/d;
                if (a>0) a = -1.0f*a;
                return (b-c)*pow(2.71, a*t)*cos(12.0*M_PI/d*t)+c;
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
    
    double _v = 0.0;
    for (int i=0; i<steps; i++) {
        _v = _calculatingBlock((double)(steps * 1.0 / (double)(steps) * i), 0.0, 100.0, (double)steps);
        [_values addObject:@(start + (_v / 100.0) * (end - start))];
    }
    
    return _values;
}
+(NSArray*)_getPointValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGPoint)start End:(CGPoint)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    
    double _v = 0.0;
    for (int i=0; i<steps; i++) {
        _v = _calculatingBlock((double)(steps * 1.0 / (double)(steps) * i), 0.0, 100.0, (double)steps);
        
        CGPoint point = {
            .x = start.x + (_v / 100.0) * (end.x - start.x),
            //_calculatingBlock((double)i, (double)start.x, (double)end.x, (double)steps),
            .y = start.y + (_v / 100.0) * (end.y - start.y),
        };
        [_values addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return _values;
}
+(NSArray*)_getSizeValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGSize)start End:(CGSize)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    
    double _v = 0.0;
    for (int i=0; i<steps; i++) {
        _v = _calculatingBlock((double)(steps * 1.0 / (double)(steps) * i), 0.0, 100.0, (double)steps);
        
        CGSize size = {
            .width = start.width + (_v / 100.0) * (end.width - start.width),
            .height  = start.height + (_v / 100.0) * (end.height - start.height),
//            .width = _calculatingBlock((double)i, (double)start.width, (double)end.width, (double)steps),
//            .height = _calculatingBlock((double)i, (double)start.height, (double)end.height, (double)steps),
        };
        [_values addObject:[NSValue valueWithCGSize:size]];
    }
    
    return _values;
}
+(NSArray*)_getRectValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGRect)start End:(CGRect)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    
    double _v = 0.0;
    for (int i=0; i<steps; i++) {
        _v = _calculatingBlock((double)(steps * 1.0 / (double)(steps) * i), 0.0, 100.0, (double)steps);
        
        CGRect rect = {
            .origin.x = start.origin.x + (_v / 100.0) * (end.origin.x - start.origin.x),
            .origin.y = start.origin.y + (_v / 100.0) * (end.origin.y - start.origin.y),
            .size.width = start.size.width + (_v / 100.0) * (end.size.width - start.size.width),
            .size.height = start.size.height + (_v / 100.0) * (end.size.height - start.size.height),
            
//            .origin.x = _calculatingBlock((double)i, (double)start.origin.x, (double)end.origin.x, (double)steps),
//            .origin.y = _calculatingBlock((double)i, (double)start.origin.y, (double)end.origin.y, (double)steps),
//            .size.width = _calculatingBlock((double)i, (double)start.size.width, (double)end.size.width, (double)steps),
//            .size.height = _calculatingBlock((double)i, (double)start.size.height, (double)end.size.height, (double)steps),
            
        };
        [_values addObject:[NSValue valueWithCGRect:rect]];
    }
    
    return _values;
}
+(NSArray*)_getCATransform3DValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CATransform3D)start End:(CATransform3D)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    
    double _v = 0.0;
    for (int i=0; i<steps; i++) {
        _v = _calculatingBlock((double)(steps * 1.0 / (double)(steps) * i), 0.0, 100.0, (double)steps);
        
        CATransform3D transform3d = {
            .m11 = start.m11 + (_v / 100.0) * (end.m11 - start.m11),
            .m12 = start.m12 + (_v / 100.0) * (end.m12 - start.m12),
            .m13 = start.m13 + (_v / 100.0) * (end.m13 - start.m13),
            .m14 = start.m14 + (_v / 100.0) * (end.m14 - start.m14),
            .m21 = start.m21 + (_v / 100.0) * (end.m21 - start.m21),
            .m22 = start.m22 + (_v / 100.0) * (end.m22 - start.m22),
            .m23 = start.m23 + (_v / 100.0) * (end.m23 - start.m23),
            .m24 = start.m24 + (_v / 100.0) * (end.m24 - start.m24),
            .m31 = start.m31 + (_v / 100.0) * (end.m31 - start.m31),
            .m32 = start.m32 + (_v / 100.0) * (end.m32 - start.m32),
            .m33 = start.m33 + (_v / 100.0) * (end.m33 - start.m33),
            .m34 = start.m34 + (_v / 100.0) * (end.m34 - start.m34),
            .m41 = start.m41 + (_v / 100.0) * (end.m41 - start.m41),
            .m42 = start.m42 + (_v / 100.0) * (end.m42 - start.m42),
            .m43 = start.m43 + (_v / 100.0) * (end.m43 - start.m43),
            .m44 = start.m44 + (_v / 100.0) * (end.m44 - start.m44),
        };
        [_values addObject:[NSValue valueWithCATransform3D:transform3d]];
    }
    
    return _values;
}

+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_AnimationFPS)kpfs Start:(id)start End:(id)end {
    
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

+(CAAnimationGroup*)A_GenerateEffect:(A_AnimationEffectType)type Duration:(double)duration {
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    [group setRemovedOnCompletion: YES];
    group.duration = duration;
    
//    CABasicAnimation *a1,*a2,*a3;
    CAKeyframeAnimation *k1; //,*k2,*k3;
    
    switch (type) {
        case A_AnimationEffectType_flash:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.5 :0.5 :1 :1];
            k1.values = @[@(0.2),@(0.8),@(0.2),@(1.0)];
             group.animations = @[k1];
            break;
        case A_AnimationEffectType_pulse:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.5 :0.5 :1 :1];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.05, 1.05, 1.05)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 0.95)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.05, 1.05, 1.05)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 0.95)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_shakeHorizontal:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
            k1.values = @[[NSValue valueWithCGPoint:CGPointMake(0.4, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.6, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.4, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.6, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.4, 0.5)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_shakeVertical:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
            k1.values = @[[NSValue valueWithCGPoint:CGPointMake(0.5, 0.4)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.6)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.4)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.6)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.4)],
                          [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_swing:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(15), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-12), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(7), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-7), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 0, 1)]];
            group.animations = @[k1];
            
            break;
            
        case A_AnimationEffectType_flipX:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.5 :1.5 :1 :1];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-360), 1, 0, 0)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-190), 1, 0, 0)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-170), 1, 0, 0)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 1, 0, 0)]];
            group.animations = @[k1];
            break;
        case A_AnimationEffectType_flipY:
            k1 = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            k1.timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.5 :1.5 :1 :1];
            k1.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-360), 0, 1, 0)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-190), 0, 1, 0)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(-170), 0, 1, 0)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 1, 0)]];
            group.animations = @[k1];
        default:
            break;
    }
    
    return group;
}

@end




