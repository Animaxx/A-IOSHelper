//
//  NSDictionary+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSDictionary+A_Extension.h"
#import "A_JSONHelper.h"

@implementation NSDictionary (A_Extension)

- (NSArray*) A_ToArray {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [result addObject:obj];
    }];
    
    return result;
}
- (NSArray*) A_SortedKeys {
    NSArray *sortedArray;
    sortedArray = [[self allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [(NSString*)b compare:(NSString*)a];
    }];
    return sortedArray;
}
- (NSData*) A_CovertToJSONData {
    return [A_JSONHelper A_ConvertDictionaryToData:self];
}
- (NSString*) A_CovertToJSONString {
    return [A_JSONHelper A_ConvertDictionaryToJSON:self];
}

- (id<NSCopying>)A_GetKey:(NSInteger)index{
    int i = 0;
    for (id key in self) {
        if (i == index) return key;
        i++;
    }
    return nil;
}
- (id)A_GetValue:(NSInteger)index {
    id key = [self A_GetKey:index];
    return [self objectForKey:key];
}

@end
