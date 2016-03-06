//
//  NSDate+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSDate+A_Extension.h"
#import "A_Datetime.h"

@implementation NSDate (A_Extension)

+ (NSDate*) A_Today {
    return [A_Datetime A_Today];
}
+ (NSDate*) A_Yesterday {
    return [A_Datetime A_Yesterday];
}
+ (NSDate*) A_Tomorrow {
    return [A_Datetime A_Tomorrow];
}
+ (NSDate*) A_ThisWeek {
    return [A_Datetime A_ThisWeek];
}
+ (NSDate*) A_LastWeek {
    return [A_Datetime A_LastWeek];
}
+ (NSDate*) A_ThisMonth {
    return [A_Datetime A_ThisMonth];
}
+ (NSDate*) A_LastMonth {
    return [A_Datetime A_LastMonth];
}
+ (NSDate*) A_CreateByYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:[NSDate dateWithTimeIntervalSince1970:0]];
    
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    
    return [calendar dateFromComponents:components];
}


- (NSTimeInterval) A_DateDiffer:(NSDate*)otherDate {
    return [A_Datetime A_DateDiffer:self Compare:otherDate];
}

- (NSDate *) toLocalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}
- (NSDate *) toGlobalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (int)A_GetWeekday {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitWeekday) fromDate:self];
    
    return (int)components.weekday;
}


- (int)A_GetYear {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitYear) fromDate:self];
    
    return (int)components.year;
}
- (int)A_GetMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitMonth) fromDate:self];
    
    return (int)components.month;
}
- (int)A_GetDay {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitDay) fromDate:self];
    
    return (int)components.day;
}
- (int)A_GetHour {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    
    return (int)components.hour;
}
- (int)A_GetMinute {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    
    return (int)components.minute;
}
- (int)A_GetSecond {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    return (int)components.second;
}

- (NSDate *)A_SetYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:self];
    
    components.year = year;
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)A_SetMonth:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:self];
    
    components.month = month;
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)A_SetDay:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:self];
    
    components.day = day;
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)A_SetHour:(NSInteger)hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:self];
    
    components.hour = hour;
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)A_SetMinute:(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:self];
    
    components.minute = minute;
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)A_SetSecond:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:self];
    
    components.second = second;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)A_GetOnlyDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone) fromDate:self];
    
    return [calendar dateFromComponents:components];
}
- (NSDate *)A_GetOnlyTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone) fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (BOOL)A_IsToday {
    return [[NSCalendar currentCalendar] isDateInToday:self];
}
- (BOOL)A_IsSameDayWith:(NSDate *)day {
    NSDateComponents *first = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *second = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:day];
    
    return (first.day == second.day && first.month == second.month && first.month == second.month && first.year == second.year && first.era == second.era);
}

- (NSString *)A_ToString:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}
- (NSString *)A_FormatByDate {
    return [self A_ToString:@"E MMM dd"];
}
- (NSString *)A_FormatByTime {
    return [self A_ToString:@"hh:mm a"];
}
- (NSString *)A_FormatByDateTime {
    return [self A_ToString:@"E MMM d YYYY, hh:mm a"];
}
- (NSString *)A_FormatToDetailString {
    return [self A_ToString:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
}

@end
