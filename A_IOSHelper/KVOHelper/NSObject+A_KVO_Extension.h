//
//  NSObject+A_KVO_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 5/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (A_KVO_Extension)

typedef void (^observerBlock) (id itself, NSDictionary *change);
typedef void (^observerBlockWithParam) (id itself, NSDictionary *change, id param);

-(void) A_AddObserver:(NSString *)key Param:(id)param block:(observerBlockWithParam)block;
-(void) A_AddObserver:(NSString *)key block:(observerBlock)block;

-(void) A_Bind:(NSString *)key To:(NSString *)to;
-(void) A_Bind:(NSString *)key To:(NSString *)to Convert:(id (^)(id value))convertBlock;
-(void) A_Bind:(NSString *)key ToTager:(id)toTager AndKey:(NSString *)toKey;
-(void) A_Bind:(NSString *)key ToTager:(id)toTager AndKey:(NSString *)toKey Convert:(id (^)(id value))convertBlock;

-(void) A_RemoveObserver: (NSString *)key;
-(void) A_RemoveBinding: (NSString *)fromKey;

-(void) A_RemoveObservings;

@end
