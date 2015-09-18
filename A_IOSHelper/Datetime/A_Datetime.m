//
//  A_Datetime.m
//  A_IOSHelper
//
//  Created by Animax on 12/24/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import "A_Datetime.h"

@implementation A_Datetime

+ (NSDate*) A_Today {
    NSCalendar *cal = [NSCalendar currentCalendar];
 
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    return today;
}
+ (NSDate*) A_Yesterday {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    return today;
}
+ (NSDate*) A_Tomorrow {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    
    [components setHour:+24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    return today;
}
+ (NSDate*) A_ThisWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components: (NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    return thisWeek;
}
+ (NSDate*) A_LastWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    return lastWeek;
}
+ (NSDate*) A_ThisMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay) fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    [components setDay:([components day] - 7)];
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    return thisMonth;
}
+ (NSDate*) A_LastMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    [components setDay:([components day] - 7)];
    [components setDay:([components day] - ([components day] -1))];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    return lastMonth;
}

+ (NSDate*) A_StringToDate:(NSString*)dateStr Format:(NSString*)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format]; //@"EE, d LLLL yyyy HH:mm:ss Z"
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    return date;
}

+ (BOOL) A_Equal:(NSDate*)firstDate With:(NSDate*)secondDate {
    return ([firstDate compare:secondDate] == NSOrderedSame);
}
+ (BOOL) A_Greater:(NSDate*)firstDate Then:(NSDate*)secondDate {
    return [firstDate compare:secondDate] == NSOrderedDescending;
}
+ (NSTimeInterval) A_DateDiffer:(NSDate*)firstDate Compare:(NSDate*)secondDate {
    if ([self A_Greater:firstDate Then:secondDate]) {
        NSTimeInterval _interval = [firstDate timeIntervalSinceDate:secondDate];
        return _interval;
    } else {
        NSTimeInterval _interval = [secondDate timeIntervalSinceDate:firstDate];
        return _interval;
    }
}


@end
