//
//  A_Reflection.h
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_Reflection : NSObject

+ (Class) A_GetClass: (id)obj;

+ (NSString*)A_GetClassName: (Class)cls;
+ (NSString*)A_GetClassNameFromObject: (id)obj;

+ (NSDictionary*) A_PropertiesFromClass: (Class)class;
+ (NSDictionary*) A_PropertiesFromObject: (id)obj;

+ (NSArray *)A_PropertieNamesFromClass: (Class)class;
+ (NSArray *)A_PropertieNamesFromObject: (id)obj;

+ (NSObject*)A_CreateObject: (NSString*) className;

@end
