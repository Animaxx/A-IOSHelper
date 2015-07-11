//
//  A_AnimationKeyframeProvider.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/26/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A_AnimationKeyframeProvider.h"

@implementation A_AnimationKeyframeProvider


#pragma mark - Keyframe animation
typedef double(^keyframeCalculatingBlock)(double t, double b, double c, double d);

+(keyframeCalculatingBlock) _methodProvider:(A_AnimationType)type {
    keyframeCalculatingBlock _calculatingBlock;
    
    switch (type) {
            // t: current time, b: begInnIng value, c: change In value, d: duration
            //http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
        case A_AnimationType_easeInQuad:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c*(t/=d)*t*t + b;
            };
            break;
        case A_AnimationType_easeOutQuad:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c*((t=t/d-1)*t*t + 1) + b;
            };
            break;
        case A_AnimationType_easeInOutQuad:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                if ((t/=d/2) < 1) return c/2*t*t*t + b;
                return c/2*((t-=2)*t*t + 2) + b;
            };
            break;
        case A_AnimationType_easeInCubic:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c*(t/=d)*t*t + b;
            };
            break;
        case A_AnimationType_easeOutCubic:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c*((t=t/d-1)*t*t + 1) + b;
            };
            break;
        case A_AnimationType_easeInOutCubic:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                if ((t/=d/2) < 1) return c/2*t*t*t + b;
                return c/2*((t-=2)*t*t + 2) + b;
            };
            break;
        case A_AnimationType_easeInQuart:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c*(t/=d)*t*t*t + b;
            };
            break;
        case A_AnimationType_easeOutQuart:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return -c * ((t=t/d-1)*t*t*t - 1) + b;
            };
            break;
        case A_AnimationType_easeInOutQuart:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
                return -c/2 * ((t-=2)*t*t*t - 2) + b;
            };
            break;

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
        case A_AnimationType_easeInSine:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return -c * cos(t/d * (M_PI/2)) + c + b;
            };
            break;
        case A_AnimationType_easeOutSine:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return c * sin(t/d * (M_PI/2)) + b;
            };
            break;
        case A_AnimationType_easeInOutSine:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return -c/2 * (cos(M_PI*t/d) - 1) + b;
            };
            break;
            
        case A_AnimationType_easeInExpo:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
            };
            break;
        case A_AnimationType_easeOutExpo:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
            };
            break;
        case A_AnimationType_easeInOutExpo:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                if (t==0) return b;
                if (t==d) return b+c;
                if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
                return c/2 * (-pow(2, -10 * --t) + 2) + b;
            };
            break;
            
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
                double a = log2f(9.0f/fabs(b-c))/d;
                if (a>0) a = -1.0f*a;
                return (b-c)*pow(2.71, a*t)*cos(6.0*M_PI/d*t)+c;
            };
            break;
        case A_AnimationType_bigLongSpring:
            _calculatingBlock = ^double(double t, double b, double c, double d) {
                double a = log2f(9.0f/fabs(b-c))/d;
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
        };
        [_values addObject:[NSValue valueWithCGRect:rect]];
    }
    
    return _values;
}
+(NSArray*)_getColorValues:(A_AnimationType)type Steps:(NSInteger)steps Start:(CGColorRef)start End:(CGColorRef)end {
    keyframeCalculatingBlock _calculatingBlock = [self _methodProvider:type];
    NSMutableArray* _values = [[NSMutableArray alloc] initWithCapacity:steps];
    
    const CGFloat* startColors = CGColorGetComponents( start );
    const CGFloat* endColors = CGColorGetComponents( end );
    
    
    double _v = 0.0;
    for (NSInteger i = 1; i < steps; i++) {
        _v = _calculatingBlock((double)(steps * 1.0 / (double)(steps) * i), 0.0, 100.0, (double)steps);
        
        UIColor *color = [UIColor
                          colorWithRed:(startColors[0] + (_v / 100.0) * (endColors[0] - startColors[0]))
                          green:(startColors[1] + (_v / 100.0) * (endColors[1] - startColors[1]))
                          blue:(startColors[2] + (_v / 100.0) * (endColors[2] - startColors[2]))
                          alpha:(startColors[3] + (_v / 100.0) * (endColors[3] - startColors[3]))];
        [_values addObject:(id)color.CGColor];
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
    } else if (CFGetTypeID((__bridge CFTypeRef)start) == CGColorGetTypeID()) {
        CGColorRef endColor;
        if ([end isKindOfClass:[UIColor class]]) {
            endColor = ((UIColor*)end).CGColor;
        } else {
            endColor = (__bridge CGColorRef)end;
        }
        animation.values = [self _getColorValues:type Steps:steps Start:(CGColorRef)start End:endColor];
    } else if (([start isKindOfClass:NSValue.class] && [end isKindOfClass:NSValue.class]) && strcmp([start objCType], [end  objCType]) == 0) {
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
