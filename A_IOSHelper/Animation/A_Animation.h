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

typedef NS_ENUM(NSUInteger, A_AnimationType) {
    A_AnimationType_easeInQuint   =1,
    A_AnimationType_easeOutQuint,
    A_AnimationType_easeInOutQuint,
    
    A_AnimationType_easeInCirc,
    A_AnimationType_easeOutCirc,
    A_AnimationType_easeInOutCirc,
    
    A_AnimationType_easeInBack,
    A_AnimationType_easeOutBack,
    A_AnimationType_easeInOutBack,
    
    A_AnimationType_easeInElastic,
    A_AnimationType_easeOutElastic,
    A_AnimationType_easeInOutElastic,
    
    A_AnimationType_easeInBounce,
    A_AnimationType_easeOutBounce,
    A_AnimationType_easeInOutBounce,
    
    A_AnimationType_spring,
    A_AnimationType_longSpring,
    A_AnimationType_bigSpring,
    A_AnimationType_bigLongSpring,
};
typedef NS_ENUM(NSUInteger, A_Animation_kFPS) {
    A_Animation_kFPS_low = 30,
    A_Animation_kFPS_middle = 45,
    A_Animation_kFPS_high = 60,
};




#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)


typedef NS_ENUM(NSUInteger, A_Animation_SystemTransitionType) {
    A_Animation_SystemTransition_Reveal     = 101,
    A_Animation_SystemTransition_MoveIn     = 102,
    A_Animation_SystemTransition_Push       = 103,
    A_Animation_SystemTransition_Fade       = 104,
};

typedef NS_ENUM(NSUInteger, A_Animation_DirectionType) {
    A_Animation_Direction_Top           = 111,
    A_Animation_Direction_Right         = 112,
    A_Animation_Direction_Bottom        = 113,
    A_Animation_Direction_Left          = 114,
};

typedef NS_ENUM(NSUInteger, A_Animation_MediaTimingType) {
    A_Animation_MeidaTiming_Spring      = 201,
};



#pragma mark - Animation Creator
+ (CAAnimation*) A_FadeIn:(double)duration;
+ (CAAnimation*) A_FadeOut:(double)duration;

+ (CAAnimation*) A_MoveTo:(double)duration OriginalPosition:(CGPoint)oiginalPosition Destination:(CGPoint)destination;
+ (CAAnimation*) A_MoveToPosition:(CGPoint)destination Duration:(double)duration;

+ (CAAnimation*) A_ChangeSize:(double)duration OriginalSize:(CGRect)oiginalBounds To:(CGSize)size;
+ (CAAnimation*) A_ChangeShapeToBall: (double)duration OriginalRadius:(CGFloat)originalradius To: (CGFloat)radius;

#pragma mark - Transition Creator
+ (CATransition*) A_CreateSystemTransition:(A_Animation_SystemTransitionType)transitionType Direction:(A_Animation_DirectionType)directionType Duration:(float)duration;

#pragma mark - Animation Executor
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations;
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations WhenCompleted:(void (^)(BOOL finished))block;
+ (void) A_SubmitTransaction: (CALayer*)layer Animations:(NSDictionary*)animations WhenCompleted:(void (^)(void))block;

+ (void) A_CardIn:(CALayer*)layer Direction:(A_Animation_DirectionType)direction Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block;
+ (void) A_CardOut:(CALayer*)layer Direction:(A_Animation_DirectionType)direction Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block;



#pragma mark - Calculating helper
+ (CGPoint) A_MakeLayerPosition: (CALayer*)layer PositionX:(float)x Y:(float)y;

#pragma mark - Keyframe animation
+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_Animation_kFPS)kpfs Start:(id)start End:(id)end;

@end


