//
//  ColorAndImageTests.m
//  A_IOSHelper
//
//  Created by Animax on 5/25/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UIColor+A_Extension.h"

@interface ColorAndImageTests : XCTestCase

@end

@implementation ColorAndImageTests

- (void)testStringToColor {
    UIColor *_result = [UIColor A_MakeColor:@"#2595cc"];
    CGFloat _red, _green, _blue, _alpha;
    [_result getRed:&_red green:&_green blue:&_blue alpha:&_alpha];
    
    XCTAssertEqual(round(_red*100), 14);
    XCTAssertEqual(round(_green*100), 58);
    XCTAssertEqual(round(_blue*100), 80);
    XCTAssertEqual(_alpha, 1);
}



@end
