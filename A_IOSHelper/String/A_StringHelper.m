//
//  A_StringHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_StringHelper.h"

@implementation A_StringHelper

+ (Boolean) A_IsEmpty:(NSString*) Str {
    return (!(Str && ![Str isKindOfClass:[NSNull class]] && ![Str isEqual:[NSNull null]] && [Str isKindOfClass:[NSString class]] && Str.length));
}

+ (NSDate*) A_StringToDate:(NSString*)dateStr Format:(NSString*)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format]; //@"EE, d LLLL yyyy HH:mm:ss Z"
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    return date;
}
+ (NSTimeInterval) A_DateDiffer:(NSDate*)firstDate Second:(NSDate*)secondDate {
    NSTimeInterval _interval = [secondDate timeIntervalSinceDate:firstDate];
    return _interval;
}


+(NSString *)A_StripHTMLTag:(NSString*)str {
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}

+(NSString *)A_TrimString:(NSString*)str {
    return [str stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
