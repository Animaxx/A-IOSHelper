//
//  NSDate+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (A_Extension)

+ (NSDate*) A_Today;
+ (NSDate*) A_Yesterday;
+ (NSDate*) A_Tomorrow;
+ (NSDate*) A_ThisWeek;
+ (NSDate*) A_LastWeek;
+ (NSDate*) A_ThisMonth;
+ (NSDate*) A_LastMonth;
- (NSTimeInterval) A_DateDiffer:(NSDate*)anotherDate;
+ (NSDate*) A_CreateByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second;

- (int)A_GetYear;
- (int)A_GetMonth;
- (int)A_GetWeekday;
- (int)A_GetDay;
- (int)A_GetHour;
- (int)A_GetMinute;
- (int)A_GetSecond;

- (NSDate *)A_SetYear:(NSInteger)year;
- (NSDate *)A_SetMonth:(NSInteger)month;
- (NSDate *)A_SetDay:(NSInteger)day;
- (NSDate *)A_SetHour:(NSInteger)hour;
- (NSDate *)A_SetMinute:(NSInteger)minute;
- (NSDate *)A_SetSecond:(NSInteger)second;

- (NSDate *)A_AddYears:(NSInteger)year;
- (NSDate *)A_AddMonth:(NSInteger)month;
- (NSDate *)A_AddDay:(NSInteger)day;
- (NSDate *)A_AddHour:(NSInteger)hour;
- (NSDate *)A_AddMinute:(NSInteger)minute;
- (NSDate *)A_AddSecond:(NSInteger)second;

- (NSDate *)A_GetOnlyDay;
- (NSDate *)A_GetOnlyTime;

- (BOOL)A_IsToday;
- (BOOL)A_IsSameDayWith:(NSDate *)day;

- (NSString *)A_ToString:(NSString *)format;
- (NSString *)A_FormatByDate;
- (NSString *)A_FormatByTime;
- (NSString *)A_FormatToDetailString;
- (NSString *)A_FormatByDateTime;

+ (NSDate *)A_ConvertStringToDate:(NSString *)str;

@end
