//
//  NSDictionary+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (A_Extension)

- (NSArray*) A_ToArray;
- (NSArray*) A_SortedKeys;
- (NSData*) A_CovertToJSONData;
- (NSString*) A_CovertToJSONString;

- (id<NSCopying>)A_GetKey:(NSInteger)index;
- (id)A_GetValue:(NSInteger)index;

@end
