//
//  UIControl+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/11/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (A_Extension)

- (void)A_Event_Add:(void (^)(id sender))handler WithObj:(id)arg forControlEvents:(UIControlEvents)controlEvents;
- (void)A_Event_Add:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;
- (void)A_Event_Remove:(UIControlEvents)controlEvent;

- (void)A_Event_OnClick:(void (^)(id sender))event WithObj:(id)arg;
- (void)A_Event_OnClick:(void (^)(id sender))event;
- (void)A_Event_RemoveClick:(void (^)(id sender))event;

@end
