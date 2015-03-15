//
//  A_Datetime.h
//  A_IOSHelper
//
//  Created by Animax on 12/24/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_Datetime : NSObject

+ (NSDate*) A_Today;
+ (NSDate*) A_Yesterday;
+ (NSDate*) A_Tomorrow;
+ (NSDate*) A_ThisWeek;
+ (NSDate*) A_LastWeek;
+ (NSDate*) A_ThisMonth;
+ (NSDate*) A_LastMonth;

+ (BOOL) A_Equal:(NSDate*)firstDate With:(NSDate*)secondDate;
+ (BOOL) A_Greater:(NSDate*)firstDate Then:(NSDate*)secondDate;

+ (NSDate*) A_StringToDate:(NSString*)dateStr Format:(NSString*)format;
+ (NSTimeInterval) A_DateDiffer:(NSDate*)firstDate Compare:(NSDate*)secondDate;

@end
