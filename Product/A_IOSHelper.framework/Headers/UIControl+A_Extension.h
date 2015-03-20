//
//  UIControl+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/11/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (A_Extension)

- (void)A_Event_Add:(void (^)(id sender, id argument))handler WithObj:(id)arg forControlEvents:(UIControlEvents)controlEvents;
- (void)A_Event_Add:(void (^)(id sender, id argument))handler forControlEvents:(UIControlEvents)controlEvents;
- (void)A_Event_Remove:(UIControlEvents)controlEvent;

- (void)A_Event_OnClick:(void (^)(id sender, id argument))event WithObj:(id)arg;
- (void)A_Event_OnClick:(void (^)(id sender, id argument))event;
- (void)A_Event_RemoveClick;

@end
