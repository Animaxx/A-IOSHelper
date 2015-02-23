//
//  A_DataModel.m
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_DataModel.h"
#import "A_Reflection.h"

@implementation A_DataModel

- (NSDictionary*)A_Serialize {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    
    NSArray *propertyList = [A_Reflection A_Properties:self];
    for (NSString *key in propertyList) {
        SEL selector = NSSelectorFromString(key);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id value = [self performSelector:selector];
#pragma clang diagnostic pop
        
        if (value == nil) {
            value = [NSNull null];
        }
        [dict setObject:value forKey:key];
    }
    return dict;
}
+ (NSObject*)A_Seserialize: (NSDictionary*)Array {
    id obj = [[[self class] alloc] init];
    
    for (NSString *key in [Array allKeys]) {
        [obj setValue:[Array objectForKey:key] forKey:key];
    }
    
    return obj;
}



@end
