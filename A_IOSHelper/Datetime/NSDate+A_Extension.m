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
- (NSTimeInterval) A_DateDiffer:(NSDate*)otherDate {
    return [A_Datetime A_DateDiffer:self Compare:otherDate];
}

-(NSDate *) toLocalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (int)A_GetMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitMonth) fromDate:self];
    
    return (int)components.month;
}
- (int)A_GetWeekday {
    NSDateComponents *components = [[NSCalendar currentCalendar]  components:(NSCalendarUnitWeekday) fromDate:self];
    
    return (int)components.weekday;
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


@end
