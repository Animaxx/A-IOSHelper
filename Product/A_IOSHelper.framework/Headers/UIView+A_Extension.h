//
//  UIView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (A_Extension)

#pragma mark - Animation
- (void) A_Animation_FadeIn: (double)duration;
- (void) A_Animation_FadeIn: (double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_FadeOut: (double)duration;
- (void) A_Animation_FadeOut: (double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_MoveOut_FromLeft: (double)duration;
- (void) A_Animation_MoveOut_FromLeft: (double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_MoveOut_FromRight: (double)duration;
- (void) A_Animation_MoveOut_FromRight: (double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_MoveOut_FromTop: (double)duration;
- (void) A_Animation_MoveOut_FromTop: (double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_MoveOut_FromBottom: (double)duration;
- (void) A_Animation_MoveOut_FromBottom: (double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_MoveToCenter: (double)duration;
- (void) A_Animation_MoveToCenter: (double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration;
- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block;
- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration;
- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration;
- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ToFullScreenSize: (double)duration;
- (void) A_Animation_ToFullScreenSize: (double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ToBall: (double)duration;
- (void) A_Animation_ToBall: (double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_ChangeCornerRadius: (CGFloat)radius Duration:(double)duration;
- (void) A_Animation_ChangeCornerRadius: (CGFloat)radius Duration:(double)duration WhenCompleted:(void (^)(void))block;

- (void) A_Animation_SubmitTransaction: (NSDictionary*)animations WhenCompleted:(void (^)(void))block;

#pragma mark - Shape
- (void) A_Shape_ToBall;


@end
