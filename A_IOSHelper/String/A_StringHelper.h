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
+ (NSDate*) A_StringToDate:(NSString*)dateStr Format:(NSString*)format;
+ (NSTimeInterval) A_DateDiffer:(NSDate*)firstDate Second:(NSDate*)secondDate;
+ (NSString *)A_StripHTMLTag:(NSString*)str;

@end
