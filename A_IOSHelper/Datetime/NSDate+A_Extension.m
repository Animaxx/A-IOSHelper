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

@end
