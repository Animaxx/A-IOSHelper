//
//  UIControl+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/11/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (A_Extension)

- (void)A_AddEvent:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;
- (void)A_RemoveEvent:(UIControlEvents)controlEvent;

- (void)A_OnClick:(void (^)(id sender))event;
- (void)A_RemoveClick:(void (^)(id sender))event;

@end
