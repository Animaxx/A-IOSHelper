//
//  NSObject+A_KVO_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 5/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (A_KVO_Extension)

-(void) A_AddObserver:(NSString*)key Param:(id)param block:(void (^)(id itself, NSDictionary* change, id param))block;
-(void) A_AddObserver:(NSString*)key block:(void (^)(id itself, NSDictionary* change))block;

-(void) A_AddObserverWithOption:(NSKeyValueObservingOptions)option Key:(NSString*)key Param:(id)param block:(void (^)(id itself, NSDictionary* change, id param))block;
-(void) A_AddObserverWithOption:(NSKeyValueObservingOptions)option Key:(NSString*)key block:(void (^)(id itself, NSDictionary* change))block;

-(void) A_Bind:(NSString*)key To:(NSString*)to;
-(void) A_Bind:(NSString*)key To:(NSString*)to Convert:(id (^)(id value))convertBlock;
-(void) A_Bind:(NSString*)key ToTager:(id)toTager AndKey:(NSString*)toKey;
-(void) A_Bind:(NSString*)key ToTager:(id)toTager AndKey:(NSString*)toKey Convert:(id (^)(id value))convertBlock;

-(void) A_RemoveObserver: (NSString*)key;
-(void) A_RemoveAllObservers;

@end
