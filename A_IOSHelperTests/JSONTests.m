//
//  JSONTests.m
//  A_IOSHelper
//
//  Created by Animax Deng on 9/22/15.
//  Copyright © 2015 AnimaxDeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "A_JSONHelper.h"

@interface JSONTests : XCTestCase

@end

@implementation JSONTests

- (void)testJSONStringToDictionary {
    NSString *testJSON = @"{ \"glossary\": { \"title\": \"example glossary\", \"GlossDiv\": { \"title\": \"S\", \"GlossList\": { \"GlossEntry\": { \"ID\": \"SGML\", \"SortAs\": \"SGML\", \"GlossTerm\": \"Standard Generalized Markup Language\", \"Acronym\": \"SGML\", \"Abbrev\": \"ISO 8879:1986\", \"GlossDef\": { \"para\": \"A meta-markup language, used to create markup languages such as DocBook.\", \"GlossSeeAlso\": [\"GML\", \"XML\"] }, \"GlossSee\": \"markup\" } } } } }";
    
    NSDictionary *dic = [A_JSONHelper A_ConvertJSONToDictionary:testJSON];
    NSLog(@"%@",dic);
    
}

@end
