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


/**
 Check if two Date are the same

 @param firstDate NSDate
 @param secondDate NSDate
 @return True for the same, false for differnet
 */
+ (BOOL) A_Equal:(NSDate*)firstDate With:(NSDate*)secondDate;

/**
 Check if the first date greater then the second one

 @param firstDate NSDate
 @param secondDate NSDate
 @return Bool
 */
+ (BOOL) A_Greater:(NSDate*)firstDate Then:(NSDate*)secondDate;


/**
 Convert String to NSDate, in default recognize as UTC timezone.

 @param dateStr Date value string
 @param format Date format string, such as "EE, d LLLL yyyy HH:mm:ss Z"
 @return NSDate
 */
+ (NSDate*) A_StringToDate:(NSString*)dateStr Format:(NSString*)format;


/**
 Convert String to NSDate

 @param dateStr Date value string
 @param format Date format string, such as "EE, d LLLL yyyy HH:mm:ss Z"
 @param timezone If not given, recognize as local timezone.
 @return NSDate
 */
+ (NSDate*) A_StringToDate:(NSString*)dateStr Format:(NSString*)format withTimezone:(NSString *)timezone;


/**
 Return the time different between two dates

 @param firstDate NSDate
 @param secondDate NSDate
 @return NSTimeInterval for seconds.
 */
+ (NSTimeInterval) A_DateDiffer:(NSDate*)firstDate Compare:(NSDate*)secondDate;

@end
