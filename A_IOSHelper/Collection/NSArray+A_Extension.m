//
//  NSArray+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSArray+A_Extension.h"
#import "A_JSONHelper.h"

@implementation NSArray (A_Extension)

- (NSDictionary*) A_CombineKeys: (NSArray*)keys {
    NSMutableDictionary *_dic = [[NSMutableDictionary alloc] init];
    for (NSUInteger i=0; i<[keys count]; i++) {
        if ([self count] > i)
            [_dic setObject:[self objectAtIndex:i] forKey:[keys objectAtIndex:i]];
        else
            [_dic setObject:[NSNull null] forKey:[keys objectAtIndex:i]];
    }
    
    return  _dic;

}
- (NSDictionary*) A_CombineValues: (NSArray*)values {
    NSMutableDictionary *_dic = [[NSMutableDictionary alloc] init];
    for (NSUInteger i=0; i<[self count]; i++) {
        if ([values count] > i)
            [_dic setObject:[values objectAtIndex:i] forKey:[self objectAtIndex:i]];
        else
            [_dic setObject:[NSNull null] forKey:[self objectAtIndex:i]];
    }
    
    return  _dic;
}
- (NSData*) A_CovertToJSONData {
    return [A_JSONHelper A_ConvertArrayToData:self];
}
- (NSString*) A_CovertToJSONString {
    return [A_JSONHelper A_ConvertArrayToJSON:self];
}

- (NSDictionary*) A_GroupBy: (id<NSCopying> (^)(id x))block {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    id key, element;
    for (element in self) {
        key = block(element);
        NSMutableArray *row = [dictionary objectForKey:key];
        if (!row) {
            row = [[NSMutableArray alloc] init];
            [dictionary setObject:row forKey:key];
        }
        [row addObject:element];
    }
    return dictionary;
}

- (NSArray*) A_Reverse {
    if ([self count] <= 1)
        return self;
    
    NSMutableArray *_result = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSInteger i=([self count]-1); i>=0; i--) {
        [_result addObject:[self objectAtIndex:i]];
    }
    
    return _result;
}
- (NSArray*) A_Take: (int)count{
    if (count > [self count]) {
        count = (int)[self count];
    }
    return [self subarrayWithRange:NSMakeRange(0, count)];
}
- (NSArray*) A_Skip: (int)count{
    if ([self count] < count) {
        return @[];
    }
    return [self subarrayWithRange:NSMakeRange(count, ([self count] - count))];
}
- (NSArray*) A_Where: (bool (^)(id x))block {
    if ([self count] <=0) {
        return self;
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    id element;
    for (element in self) {
        if (block(element)) {
            [result addObject:element];
        }
    }
    return result;
}

- (void) A_Each: (void (^)(id x))block {
    id element;
    for (element in self) {
        block(element);
    }
}
- (BOOL) A_Any: (bool (^)(id x))block {
    id element;
    for (element in self) {
        if (block(element)) {
            return YES;
        }
    }
    return NO;
}
- (id) A_FirstOrNil: (bool (^)(id x))block {
    id element;
    for (element in self) {
        if (block(element)) {
            return element;
        }
    }
    return nil;
}
- (id) A_LastOrNil: (bool (^)(id x))block {
    for (NSInteger i=([self count]-1); i>=0; i--) {
        if (block([self objectAtIndex:i])) {
            return [self objectAtIndex:i];
        }
    }
    return nil;
}

@end
