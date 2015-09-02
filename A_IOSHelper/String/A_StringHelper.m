//
//  A_StringHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_StringHelper.h"

@implementation A_StringHelper

+ (BOOL) A_CheckEmpty:(NSString*) Str {
    return (!(Str && ![Str isKindOfClass:[NSNull class]] && ![Str isEqual:[NSNull null]] && [Str isKindOfClass:[NSString class]] && Str.length));
}

+ (NSString *)A_StripHTMLTag:(NSString*)str {
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}

+ (NSString *)A_TrimString:(NSString*)str {
    return [str stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL) A_ValidateEmail:(NSString*)str {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self A_Match:str WithRegex:emailRegex];
}

+ (BOOL)A_Match:(NSString*)str WithRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

+ (NSString *)A_ExtractSubstring:(NSString *)prefix postfix:(NSString *)postfix sentence:(NSString *)sentence index:(NSInteger *)index {
    NSRange range = [sentence rangeOfString:prefix options:0 range:NSMakeRange((*index), sentence.length - (*index))];
    if (range.location != NSNotFound) {
        NSRange lastRange = [sentence rangeOfString:postfix options:0 range:NSMakeRange(range.location, sentence.length - range.location)];
        if (lastRange.location == NSNotFound) {
            return nil;
        }
        
        *index = lastRange.location;
        
        NSRange finalRange = NSMakeRange(range.location + range.length, lastRange.location-range.location-range.length);
        NSString *param = [sentence substringWithRange:finalRange];
        
        return param;
    } else {
        return nil;
    }
}


@end
