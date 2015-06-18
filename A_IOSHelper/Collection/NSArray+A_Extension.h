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

- (NSArray*) A_Reverse;
- (NSArray*) A_Take: (int)count;
- (NSArray*) A_Skip: (int)count;
- (NSArray*) A_Where: (bool (^)(id x))block;

- (void) A_Each: (void (^)(id x))block;
- (BOOL) A_Any: (bool (^)(id x))block;
- (id) A_FirstOrNil: (bool (^)(id x))block;
- (id) A_LastOrNil: (bool (^)(id x))block;

@end
