//
//  CollectionHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_CollectionHelper.h"

@implementation A_CollectionHelper

+ (NSArray*)A_DictionaryToArray:(NSDictionary*)dict {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:6];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [result addObject:obj];
    }];
    
    return result;
}

+ (NSDictionary*)A_CombineArraysToDictionary: (NSArray*)Keys Values:(NSArray*)values {
    NSMutableDictionary* _dic = [[NSMutableDictionary alloc] init];
    for (NSUInteger i=0; i<[Keys count]; i++) {
        if ([values count] > i)
            [_dic setObject:[values objectAtIndex:i] forKey:[Keys objectAtIndex:i]];
        else
            [_dic setObject:[NSNull null] forKey:[Keys objectAtIndex:i]];
    }
    
    return  _dic;
}

+ (NSArray *)A_SortedKeys:(NSDictionary*) dic {
    NSArray *sortedArray;
    sortedArray = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [(NSString*)b compare:(NSString*)a];
    }];
    return sortedArray;
}

+ (void)A_SwapArray: (NSMutableArray*)array1 With:(NSMutableArray*)array2 {
    if (!array1 || !array2) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Error occur in swap array>  \r\n Can not swap with nil \r\n -------- \r\n\r\n");
        return;
    }
    
    NSUInteger length = [array1 count];
    if ([array2 count] < length) length = [array2 count];
    
    for (NSUInteger i=0; i<length; i++) {
        id temp = [array2 objectAtIndex:i];
        [array2 replaceObjectAtIndex:i withObject:[[array1 objectAtIndex:i] copy]];
        [array1 replaceObjectAtIndex:i withObject:temp];
    }
}

+ (void)A_SwapDictionary:(NSMutableDictionary *)dictionary1 With:(NSMutableDictionary *)dictionary2 {
    id key;
    for (key in dictionary1) {
        if ([dictionary1 objectForKey:key] && [dictionary2 objectForKey:key]) {
            id temp = [dictionary2 objectForKey:key];
            [dictionary2 setObject:[dictionary1 objectForKey:key] forKey:key];
            [dictionary1 setObject:[temp copy] forKey:key];
        }
    }
}

@end
