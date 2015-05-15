//
//  NSObject+A_KVO_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 5/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (A_KVO_Extension)

-(void) A_AddObserver:(NSString*)key
               Option:(NSKeyValueObservingOptions)option
                Param:(id)param
                block:(void (^)(NSObject* itself, NSDictionary* change, id param))block;

-(void) A_AddObserver:(NSString*)key
               Option:(NSKeyValueObservingOptions)option
                block:(void (^)(NSObject* itself, NSDictionary* change))block;

- (void) A_RemoveObserver: (NSString*)key;

@end
