//
//  NSDictionary+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSDictionary+A_Extension.h"
#import "A_CollectionHelper.h"
#import "A_JSONHelper.h"

@implementation NSDictionary (A_Extension)

- (NSArray*) A_ToArray {
    return [A_CollectionHelper A_DictionaryToArray:self];
}
- (NSArray*) A_SortedKeys {
    return [A_CollectionHelper A_SortedKeys:self];
}
- (NSData*) A_CovertToJSONData {
    return [A_JSONHelper A_ConvertDictionaryToData:self];
}
- (NSString*) A_CovertToJSONString {
    return [A_JSONHelper A_ConvertDictionaryToJSON:self];
}

@end
