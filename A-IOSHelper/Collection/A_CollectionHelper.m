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
    for (int i=0; i<[Keys count]; i++) {
        if ([values count] < i)
            [_dic setObject:[values objectAtIndex:i] forKey:[Keys objectAtIndex:i]];
        else
            [_dic setObject:nil forKey:[Keys objectAtIndex:i]];
    }
    
    return  _dic;
}

+ (NSArray *) A_SortedKeys:(NSDictionary*) dic {
    NSArray *sortedArray;
    sortedArray = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [(NSString*)b compare:(NSString*)a];
        //return [(NSString*)a compare:(NSString*)b];
    }];
    return sortedArray;
}


@end
