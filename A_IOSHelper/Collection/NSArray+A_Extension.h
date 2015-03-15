//
//  NSArray+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (A_Extension)

- (NSDictionary*) A_CombineKeys: (NSArray*)keys;
- (NSDictionary*) A_CombineValues: (NSArray*)values;
- (NSData*) A_CovertToJSONData;
- (NSString*) A_CovertToJSONString;

@end
