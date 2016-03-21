//
//  NSObject+A_ConvertToCollection.m
//  A_IOSHelper
//
//  Created by Animax Deng on 3/19/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import "NSObject+A_ConvertToCollection.h"
#import <objc/runtime.h>
#import "A_Reflection.h"

@implementation NSObject (A_ConvertToCollection)

- (NSDictionary<NSString *, id> *)A_ConvertToDictionary {
    NSDictionary<NSString *, NSString *> *properties = [A_Reflection A_PropertiesFromObject:self];
    A_Dictionary *result = [[A_Dictionary alloc] initWithCapacity:properties.count];
    
    for (NSString *key in properties) {
        id val = [self valueForKey:key];
        if (val) {
            [result setObject:val forKey:key];
        }
    }
    
    return result;
}

- (NSDictionary<NSString *, id> *)A_ConvertToDictionaryWithContent {
    NSDictionary<NSString *, NSString *> *properties = [A_Reflection A_PropertiesFromObject:self];
    A_Dictionary *result = [[A_Dictionary alloc] initWithCapacity:properties.count];
    
    for (NSString *key in properties) {
        id val = [self valueForKey:key];
        if (val) {
            // to avoid parsing cyclic pointing
            if (val == self) {
                continue;
            }
            u_int count;
            class_copyPropertyList ([val class], &count);
            if (count) {
                [result setObject:[val A_ConvertToDictionaryWithContent] forKey:key];
            } else {
                [result setObject:val forKey:key];
            }
        }
    }
    
    return result;
}

@end
