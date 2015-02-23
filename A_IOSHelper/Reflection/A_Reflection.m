//
//  A_Reflection.m
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_Reflection.h"
#import <objc/runtime.h>

@implementation A_Reflection

+ (Class) A_GetClass: (id)obj {
    return object_getClass(obj);
}

+ (NSArray *)A_Properties: (id)obj{
    Class _class = [A_Reflection A_GetClass:obj];
    if (!_class) {
        return [[NSArray alloc] init];
    }
    
    u_int count;
    objc_property_t *properties = class_copyPropertyList(_class, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties); 
    return propertyArray;
}

+ (NSObject*)A_CreateObject: (NSString*) className {
    return [[NSClassFromString(className) alloc] init];
}




+ (void)A_Methods: (id)obj {
//    class_copyMethodList
    
    
    
}

@end
