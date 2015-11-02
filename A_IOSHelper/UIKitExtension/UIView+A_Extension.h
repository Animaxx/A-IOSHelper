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

@end
