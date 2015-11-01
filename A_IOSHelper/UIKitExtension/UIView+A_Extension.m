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

- (NSArray<UIView *> *) A_GetSubView:(bool (^)(id x))block {
     return [self.subviews A_Where:block];
}

- (UIView *) A_GetFirstSubView:(bool (^)(id x))block {
    return [self.subviews A_FirstOrNil:block];
}

@end
