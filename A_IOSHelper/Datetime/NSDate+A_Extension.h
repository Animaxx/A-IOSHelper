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

- (int)A_GetMonth;
- (int)A_GetWeekday;
- (int)A_GetDay;
- (int)A_GetHour;
- (int)A_GetMinute;
- (int)A_GetSecond;

@end
