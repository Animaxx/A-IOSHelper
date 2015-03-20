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

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)


typedef NS_ENUM(NSInteger, A_Animation_SystemTransitionType) {
    A_Animation_SystemTransition_Reveal     = 101,
    A_Animation_SystemTransition_MoveIn     = 102,
    A_Animation_SystemTransition_Push       = 103,
    A_Animation_SystemTransition_Fade       = 104,
};

typedef NS_ENUM(NSInteger, A_Animation_DirectionType) {
    A_Animation_Direction_Top           = 111,
    A_Animation_Direction_Right         = 112,
    A_Animation_Direction_Bottom        = 113,
    A_Animation_Direction_Left          = 114,
};

typedef NS_ENUM(NSInteger, A_Animation_MediaTimingType) {
    A_Animation_MeidaTiming_Spring      = 201,
};



#pragma mark - Animation Creator
+ (CABasicAnimation*) A_FadeIn:(double)duration;
+ (CABasicAnimation*) A_FadeOut:(double)duration;

+ (CABasicAnimation*) A_MoveTo:(double)duration OriginalPosition:(CGPoint)oiginalPosition Destination:(CGPoint)destination;
+ (CABasicAnimation*) A_MoveToPosition:(CGPoint)destination Duration:(double)duration;

+ (CABasicAnimation*) A_ChangeSize:(double)duration OriginalSize:(CGRect)oiginalBounds To:(CGSize)size;
+ (CABasicAnimation*) A_ChangeShapeToBall: (double)duration OriginalRadius:(CGFloat)originalradius To: (CGFloat)radius;

#pragma mark - Transition Creator
+ (CATransition*) A_CreateSystemTransition:(A_Animation_SystemTransitionType)transitionType Direction:(A_Animation_DirectionType)directionType Duration:(float)duration;

#pragma mark - Media Timing Creator
+ (CAMediaTimingFunction*) A_CreateMediaTimingFunction: (A_Animation_MediaTimingType)type;

#pragma mark - Animation Executor
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations;
+ (void) A_AnimationBlock: (double)duration Animation:(void (^)(void))animations WhenCompleted:(void (^)(BOOL finished))block;
+ (void) A_SubmitTransaction: (CALayer*)layer Animations:(NSDictionary*)animations WhenCompleted:(void (^)(void))block;

+ (void) A_CardIn:(CALayer*)layer Direction:(A_Animation_DirectionType)direction Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block;
+ (void) A_CardOut:(CALayer*)layer Direction:(A_Animation_DirectionType)direction Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block;



#pragma mark - Calculating helper
+ (CGPoint) A_MakeLayerPosition: (CALayer*)layer PositionX:(float)x Y:(float)y;

@end


