//
//  A_Reflection.h
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_Reflection : NSObject

+ (Class)A_GetClassByName:(NSString *)name;
+ (Class)A_GetClass:(id)obj;

+ (NSString *)A_GetClassName:(Class)cls;
+ (NSString *)A_GetClassNameFromObject:(id)obj;

+ (NSDictionary<NSString *, NSString *> *)A_PropertiesFromClass:(Class)cls;
+ (NSDictionary<NSString *, NSString *> *)A_PropertiesFromObject:(id)obj;

+ (NSArray<NSString *> *)A_PropertieNamesFromClass:(Class)cls;
+ (NSArray<NSString *> *)A_PropertieNamesFromObject:(id)obj;

+ (NSObject *)A_CreateObject:(NSString *)className;

@end
