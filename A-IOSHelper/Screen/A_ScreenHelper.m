//
//  ScreenHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_ScreenHelper.h"
#import <UIKit/UIKit.h>

@implementation A_ScreenHelper

+ (NSInteger)A_CurrectWidth {
    return (NSInteger)[[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale;
}
+ (NSInteger)A_CurrectHeight {
    return (NSInteger)[[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale;
}

@end
