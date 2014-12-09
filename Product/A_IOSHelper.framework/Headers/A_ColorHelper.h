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

+ (NSNumber*) A_ToNumber: (NSString*) hex;
+ (NSArray *) A_SpliteColor:(NSString*) colorString;
+ (UIColor*) A_GetColorByString:(NSString*) str;

@end
