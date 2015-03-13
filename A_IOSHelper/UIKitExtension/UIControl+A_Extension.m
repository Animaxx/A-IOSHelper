//
//  UIControl+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/11/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <objc/runtime.h>
#import "UIControl+A_Extension.h"
#import "A_BlockWrapper.h"

@implementation UIControl (A_Extension)

static char _a_associatedObjectKey;

- (void)A_AddEvent:(void (^)(id sender))event forControlEvents:(UIControlEvents)controlEvent {
    NSParameterAssert(event);
    
    NSMutableDictionary *events = objc_getAssociatedObject(self, &_a_associatedObjectKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &_a_associatedObjectKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvent);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    A_BlockWrapper* _block = [A_BlockWrapper A_Init:(__bridge void *)(event)];
	[handlers addObject:_block];
    [self addTarget:_block action:@selector(A_Execute:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)A_RemoveEvent:(UIControlEvents)controlEvent {
    NSMutableDictionary *events = objc_getAssociatedObject(self, &_a_associatedObjectKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &_a_associatedObjectKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvent);
    NSSet *handlers = events[key];
    
    if (!handlers)
        return;
    
    [handlers enumerateObjectsUsingBlock:^(id sender, BOOL *stop) {
        [self removeTarget:sender action:NULL forControlEvents:controlEvent];
    }];
    
    [events removeObjectForKey:key];
}

- (void)A_OnClick:(void (^)(id sender))event {
    [self A_AddEvent:event forControlEvents:UIControlEventTouchUpInside];
}
- (void)A_RemoveClick:(void (^)(id sender))event {
    [self A_RemoveEvent:UIControlEventTouchUpInside];
}

@end
