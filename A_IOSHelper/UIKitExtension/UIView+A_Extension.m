//
//  UIView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax Deng on 11/1/15.
//  Copyright © 2015 AnimaxDeng. All rights reserved.
//

#import "UIView+A_Extension.h"
#import "NSArray+A_Extension.h"

@implementation UIView (A_Extension)

- (NSArray<UIView *> *) A_GetSubView:(bool (^)(UIView *x))block {
    return [self.subviews A_Where:block];
}

- (UIView *) A_GetFirstSubView:(bool (^)(UIView *x))block {
    return [self.subviews A_FirstOrNil:block];
}

- (UIColor *) A_ExtractColor:(CGPoint)point {
    unsigned char pixel[4] = {0};
    UIColor *color = nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    if((pixel[0] > 0) && (pixel[1] > 0) && (pixel[2] > 0)) {
        color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    }
    
    return color;
}

@end
