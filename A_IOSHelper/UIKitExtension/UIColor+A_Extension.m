//
//  UIColor+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/19/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "UIColor+A_Extension.h"
#import "A_ColorHelper.h"

@implementation UIColor (A_Extension)

+ (UIColor*) A_MakeColor:(NSString*) str {
    return [A_ColorHelper A_ColorMakeFormString:str];
}

@end
