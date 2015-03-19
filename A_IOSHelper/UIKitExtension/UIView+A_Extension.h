//
//  UIView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A_Animation.h"

@interface UIView (A_Extension)

#pragma mark - Animation - Movement
- (void) A_Animation_MoveOut: (A_Animation_DirectionType)directionType Duration:(double)duration;
- (void) A_Animation_MoveOut: (A_Animation_DirectionType)directionType Duration:(double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_CardIn: (A_Animation_DirectionType)directionType Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block;
- (void) A_Animation_CardOut: (A_Animation_DirectionType)directionType Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block;

- (void) A_Animation_MoveToCenter: (double)duration;
- (void) A_Animation_MoveToCenter: (double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration;
- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration;
- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_Transition:(A_Animation_SystemTransitionType)transitionType Direction:(A_Animation_DirectionType)directionType Duration:(float)duration;
- (void) A_Animation_Transition:(A_Animation_SystemTransitionType)transitionType Direction:(A_Animation_DirectionType)directionType Duration:(float)duration WhenCompleted:(void (^)(void))block;

#pragma mark - Animation - Change Shape
- (void) A_Animation_FadeIn: (double)duration;
- (void) A_Animation_FadeIn: (double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_FadeOut: (double)duration;
- (void) A_Animation_FadeOut: (double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration;
- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ToFullScreenSize: (double)duration;
- (void) A_Animation_ToFullScreenSize: (double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ToBall: (double)duration;
- (void) A_Animation_ToBall: (double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ChangeCornerRadius: (CGFloat)radius Duration:(double)duration;
- (void) A_Animation_ChangeCornerRadius: (CGFloat)radius Duration:(double)duration WhenCompleted:(void (^)(void))block;

#pragma mark - Animation - Execute
- (void) A_Animation_SubmitTransaction: (NSDictionary*)animations WhenCompleted:(void (^)(void))block;

#pragma mark - Shape
- (void) A_Shape_ToBall;


@end
