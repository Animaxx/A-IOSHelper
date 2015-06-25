//
//  UIViewController+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/18/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "UIViewController+A_Extension.h"

@implementation UIViewController (A_Extension)

/*
- (void) A_Animation_TransitionFrom:(UIView*)viewA
                          ReplaceTo:(UIView*)viewB
                         Transition:(A_Animation_SystemTransitionType)transitionType
                          Direction:(A_Animation_DirectionType)directionType
                           Duration:(float)duration {
    [CATransaction begin]; {
        CATransition* _transition = [A_Animation A_CreateSystemTransition:transitionType Direction:directionType Duration:duration];
        
        [viewB setHidden:YES];
        [self.view addSubview:viewB];
        [viewB setHidden:YES];
        [viewB setBounds:viewA.bounds];
        [viewB setFrame:viewA.frame];
        
        [viewA.layer addAnimation:_transition forKey:kCATransition];
        [viewB.layer addAnimation:_transition forKey:kCATransition];
        
        [viewA setHidden:YES];
        [viewB setHidden:NO];
    } [CATransaction commit];
}

- (void) A_Animation_TransitionFrom:(UIView*)viewA
                          ReplaceTo:(UIView*)viewB
                         Transition:(A_Animation_SystemTransitionType)transitionType
                          Direction:(A_Animation_DirectionType)directionType
                           Duration:(float)duration
                      WhenCompleted:(void (^)(void))block {
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        CATransition* _transition = [A_Animation A_CreateSystemTransition:transitionType Direction:directionType Duration:duration];
        
        [viewB setHidden:YES];
        [self.view addSubview:viewB];
        [viewB setBounds:viewA.bounds];
        [viewB setFrame:viewA.frame];
        
        [viewA.layer addAnimation:_transition forKey:kCATransition];
        [viewB.layer addAnimation:_transition forKey:kCATransition];
        
        [viewA setHidden:YES];
        [viewB setHidden:NO];
    } [CATransaction commit];
}
*/
 
@end
