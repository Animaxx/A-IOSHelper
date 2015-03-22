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

+ (NSArray *)A_PropertiesFromClass: (Class)class;
+ (NSArray *)A_Properties: (id)obj;

+ (NSObject*)A_CreateObject: (NSString*) className;

@end
