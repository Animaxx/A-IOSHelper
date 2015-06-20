//
//  NSMutableDictionary+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/24/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSMutableDictionary+A_Extension.h"

@implementation NSMutableDictionary(A_Extension)

- (void)A_Swap:(NSMutableDictionary*)dictionary{
    id key;
    for (key in self) {
        if ([self objectForKey:key] && [dictionary objectForKey:key]) {
            id temp = [dictionary objectForKey:key];
            [dictionary setObject:[self objectForKey:key] forKey:key];
            [self setObject:[temp copy] forKey:key];
        }
    }
}

@end
