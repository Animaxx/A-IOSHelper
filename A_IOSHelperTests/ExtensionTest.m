//
//  ExtensionTest.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/30/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+A_Extension.h"

@interface ExtensionTest : XCTestCase

@end

@implementation ExtensionTest

- (void)testSetExtraProperty {
    NSObject *newObj = [[NSObject alloc] init];
    
    [newObj A_SetProperty:@"value" to:@"key"];
    NSString *val = [newObj A_GetProperty:@"key"];
    
    XCTAssertNotNil(val);
    XCTAssertEqual(val, @"value");
}
- (void)testSetExtraProperyWithObjectKey {
    NSObject *newObj = [[NSObject alloc] init];
    
    [newObj A_SetProperty:@"value" to:[[ExtensionTest alloc] init]];
    NSString *val = [newObj A_GetProperty:[[ExtensionTest alloc] init]];
    
    XCTAssertNotNil(val);
    XCTAssertEqual(val, @"value");
}
- (void)testSetDuplicatedExtraPropery {
    NSObject *newObj = [[NSObject alloc] init];
    
    [newObj A_SetProperty:@"value" to:@"key"];
    [newObj A_SetProperty:@"value1" to:@"key"];
    NSString *val = [newObj A_GetProperty:@"key"];
    
    XCTAssertNotNil(val);
    XCTAssertEqual(val, @"value1");
}
- (void)testSetWeakExtraProperty {
    NSObject *newObj = [[NSObject alloc] init];
    
    NSString *value = @"value";
    [newObj A_SetProperty:value to:@"key" with:A_ExtraPropertPolicy_Assign];
    NSString *val = [newObj A_GetProperty:@"key"];
    XCTAssertNotNil(val);
    XCTAssertEqual(val, value);

    value = nil;
    val = nil;
}
- (void)testSetBlockToExtraProperty {
    NSObject *newObj = [[NSObject alloc] init];
    
    double (^testBlock)(double a);
    testBlock = ^double(double a){
        return a * 2.0f;
    };
    
    [newObj A_SetProperty:testBlock to:@"key" with:A_ExtraPropertPolicy_Copy_Nonatomic];
    
    double (^valBlock)(double a) = [newObj A_GetProperty:@"key"];
    XCTAssertNotNil(valBlock);
    
    double val = valBlock(100.1f);
    XCTAssertEqual(val, 200.2f);
}

@end
