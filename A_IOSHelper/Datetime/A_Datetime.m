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
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    return today;
}
+ (NSDate*) A_Yesterday {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    return today;
}
+ (NSDate*) A_Tomorrow {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:+24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    return today;
}
+ (NSDate*) A_ThisWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    return thisWeek;
}
+ (NSDate*) A_LastWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    return lastWeek;
}
+ (NSDate*) A_ThisMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    [components setDay:([components day] - 7)];
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    return thisMonth;
}
+ (NSDate*) A_LastMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    [components setDay:([components day] - 7)];
    [components setDay:([components day] - ([components day] -1))];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    return lastMonth;
}

@end
