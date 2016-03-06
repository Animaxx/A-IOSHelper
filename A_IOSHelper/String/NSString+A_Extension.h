//
//  NSString+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (A_Extension)

- (BOOL) A_CheckEmpty;
- (NSString*) A_StripHTMLTag;
- (NSString*) A_TrimString;
- (BOOL) A_ValidateEmail;
- (BOOL) A_MatchRegex: (NSString *)regex;
- (NSDate*) A_ToDate:(NSString*)format;
- (NSDate *)A_ToDateByDetailFormat;

- (NSDictionary*) A_CovertJSONToDictionary;
- (NSArray*) A_CovertJSONToArray;

@end
