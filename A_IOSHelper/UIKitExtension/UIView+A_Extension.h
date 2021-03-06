//
//  UIView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax Deng on 11/1/15.
//  Copyright © 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (A_Extension)

- (NSArray<UIView *> *) A_GetSubView:(bool (^)(UIView *x))block;

- (UIView *) A_GetFirstSubView:(bool (^)(UIView *x))block;

- (UIColor *) A_ExtractColor:(CGPoint)point;

- (void) A_SetViewSize:(CGSize)size;

- (void) A_SetViewHeight:(CGFloat)height;

- (void) A_SetViewWeight:(CGFloat)width;

- (void) A_SetViewPosition:(CGPoint)position;

- (void) A_SetViewPositionX:(CGFloat)x;

- (void) A_SetViewPositionY:(CGFloat)y;

- (CGFloat) A_GetViewHeight;

- (CGFloat) A_GetViewWeight;

- (CGFloat) A_GetViewPositionX;

- (CGFloat) A_GetViewPositionY;

@end
