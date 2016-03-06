//
//  NSString+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_Datetime.h"
#import "A_JSONHelper.h"
#import "A_StringHelper.h"
#import "NSString+A_Extension.h"

@implementation NSString (A_Extension)

- (BOOL)A_CheckEmpty {
	return [A_StringHelper A_CheckEmpty:self];
}
- (NSString *)A_StripHTMLTag {
	return [A_StringHelper A_StripHTMLTag:self];
}
- (NSString *)A_TrimString {
	return [A_StringHelper A_TrimString:self];
}
- (BOOL)A_ValidateEmail {
	return [A_StringHelper A_ValidateEmail:self];
}
- (BOOL)A_MatchRegex:(NSString *)regex {
	return [A_StringHelper A_Match:self WithRegex:regex];
}
- (NSDate *)A_ToDate:(NSString *)format {
	return [A_Datetime A_StringToDate:self Format:format];
}
- (NSDate *)A_ToDateByDetailFormat {
    return [A_Datetime A_StringToDate:self Format:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
}

- (NSDictionary *)A_CovertJSONToDictionary {
	return [A_JSONHelper A_ConvertJSONToDictionary:self];
}
- (NSArray *)A_CovertJSONToArray {
	return [A_JSONHelper A_ConvertJSONToArray:self];
}


@end
