//
//  ColorHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_ColorHelper.h"

@implementation A_ColorHelper

+ (NSNumber*) A_ToNumber: (NSString*) hex {
    hex = [hex uppercaseString];
    
    int val = 0;
    int res = 0;
    
    for (int i = 0; i < 2; i++) {
        char c = [hex characterAtIndex:i];
        
        switch (c) {
            case 'A':
                val = 10;
                break;
            case 'B':
                val = 11;
                break;
            case 'C':
                val = 12;
                break;
            case 'D':
                val = 13;
                break;
            case 'E':
                val = 14;
                break;
            case 'F':
                val = 15;
                break;
            default:
                val = [[NSNumber numberWithChar:c] intValue] - 48;
                if (val < 0 || val > 9) {
                    val = 0;
                }
                
                break;
        }
        
        res += val * pow(16, 1 - i);
    }
    
    return [NSNumber numberWithInt:res - 1];
}
+ (NSArray *) A_SpliteColor:(NSString*) colorString {
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    for (int i = 0; i < 3; i++) {
        NSRange range = NSMakeRange(i * 2, 2);
        [colors addObject: [self A_ToNumber: [colorString substringWithRange:range]]];
    }
    
    return colors;
}

+ (UIColor*) MakeColorByR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b {
    return [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:1.0f];
}
+ (UIColor*) A_ColorMakeFormString:(NSString*) str {
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    }
    
    NSArray *colors = [self A_SpliteColor: str];
    
    NSNumber *red = [colors objectAtIndex:0];
    NSNumber *green = [colors objectAtIndex:1];
    NSNumber *blue = [colors objectAtIndex:2];
    
    UIColor *color = [UIColor colorWithRed:[red floatValue] / 255.0
                                     green:[green floatValue] /255.0
                                      blue:[blue floatValue] /255.0
                                     alpha:1];
    
    return color;
}

@end
