//
//  A_StringHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_StringHelper : NSObject

+ (BOOL) A_IsEmpty:(NSString*) Str;
+ (NSString *)A_StripHTMLTag:(NSString*)str;
+ (NSString *)A_TrimString:(NSString*)str;
+ (BOOL) A_ValidateEmail:(NSString*)str;
+ (BOOL)A_Matche:(NSString*)str WithRegex:(NSString *)regex;

@end
