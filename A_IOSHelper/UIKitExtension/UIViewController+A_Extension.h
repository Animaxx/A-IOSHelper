//
//  UIViewController+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/18/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A_Animation.h"

@interface UIViewController (A_Extension)

#pragma mark - Transition from animation
- (void) A_Animation_TransitionFrom:(UIView*)viewA
                          ReplaceTo:(UIView*)viewB
                         Transition:(A_Animation_SystemTransitionType)transitionType
                          Direction:(A_Animation_DirectionType)directionType
                           Duration:(float)duration;
- (void) A_Animation_TransitionFrom:(UIView*)viewA
                          ReplaceTo:(UIView*)viewB
                         Transition:(A_Animation_SystemTransitionType)transitionType
                          Direction:(A_Animation_DirectionType)directionType
                           Duration:(float)duration
                      WhenCompleted:(void (^)(void))block;




@end
