//
//  UIView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (A_Extension)

- (void) A_Animation_FadeIn: (double)duration;
- (void) A_Animation_FadeOut: (double)duration;

- (void) A_Animation_MoveOut_FromLeft: (double)duration;
- (void) A_Animation_MoveOut_FromRight: (double)duration;
- (void) A_Animation_MoveOut_FromTop: (double)duration;
- (void) A_Animation_MoveOut_FromBottom: (double)duration;

@end
