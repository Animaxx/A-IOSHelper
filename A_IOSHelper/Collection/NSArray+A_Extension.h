//
//  NSArray+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (A_Extension)

- (NSDictionary*) A_CombineKeys: (NSArray*)keys;
- (NSDictionary*) A_CombineValues: (NSArray*)values;
- (NSData*) A_CovertToJSONData;
- (NSString*) A_CovertToJSONString;

- (NSDictionary*) A_GroupBy: (id<NSCopying> (^)(ObjectType x))block;

- (NSArray<ObjectType>*) A_Reverse;
- (NSArray<ObjectType>*) A_Take: (int)count;
- (NSArray<ObjectType>*) A_Skip: (int)count;
- (NSArray<ObjectType>*) A_Where: (bool (^)(ObjectType x))block;
- (NSArray *) A_Extract: (id (^)(ObjectType x))block;

- (void) A_Each: (void (^)(ObjectType x))block;
- (BOOL) A_Any: (bool (^)(ObjectType x))block;
- (ObjectType) A_FirstOrNil: (bool (^)(ObjectType x))block;
- (ObjectType) A_LastOrNil: (bool (^)(ObjectType x))block;

- (NSArray<ObjectType> *) A_First:(NSInteger)n block: (bool (^)(ObjectType x))block;
- (NSArray<ObjectType> *) A_Last:(NSInteger)n block: (bool (^)(ObjectType x))block;

@end
