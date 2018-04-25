//
//  NSDictionary+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary<KType,VType> (A_Extension)

- (NSArray<VType>*) A_ToArray;
- (NSArray<KType>*) A_SortedKeys;
- (NSData*) A_CovertToJSONData;
- (NSString*) A_CovertToJSONString;

- (KType)A_GetKey:(NSInteger)index;
- (VType)A_GetValue:(NSInteger)index;

@end
