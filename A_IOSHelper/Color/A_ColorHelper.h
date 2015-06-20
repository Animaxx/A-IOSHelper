//
//  ColorHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface A_ColorHelper : NSObject

+ (UIColor*) MakeColorByR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;
+ (UIColor*) A_ColorMakeFormString:(NSString*) str;

@end
