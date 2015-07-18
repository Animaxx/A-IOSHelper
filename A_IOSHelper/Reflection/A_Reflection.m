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

+ (Class) A_GetClassByName: (NSString*)name {
    return NSClassFromString(name);
}
+ (Class) A_GetClass: (id)obj {
    return object_getClass(obj);
}

+ (NSString*)A_GetClassName: (Class)cls {
    return NSStringFromClass(cls);
}
+ (NSString*)A_GetClassNameFromObject: (id)obj {
    return NSStringFromClass([self A_GetClass:obj]);
}

+ (NSDictionary*) A_PropertiesFromClass: (Class)class{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableDictionary *propertyDictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        const char *type = property_getAttributes(properties[i]);
        NSArray *propertyAttributes = [[NSString stringWithUTF8String:type] componentsSeparatedByString:@","];
        NSString *typeAttribute = [propertyAttributes objectAtIndex:0];
        NSString *propertyType = [typeAttribute substringFromIndex:1];
        
        if ([typeAttribute hasPrefix:@"T@"]) { // Class type
            NSRange stringRange = {2, [propertyType length]-3};
            [propertyDictionary setObject:[propertyType substringWithRange:stringRange] forKey:propertyName];
        } else { // value type
            const char *rawPropertyType = [propertyType UTF8String];
            if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
                [propertyDictionary setObject:@"BOOL" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(bool)) == 0) {
                [propertyDictionary setObject:@"bool" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(char)) == 0) {
                [propertyDictionary setObject:@"char" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(short)) == 0) {
                [propertyDictionary setObject:@"short" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
                [propertyDictionary setObject:@"long" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
                [propertyDictionary setObject:@"float" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
                [propertyDictionary setObject:@"double" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
                [propertyDictionary setObject:@"int" forKey:propertyName];
            } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
                [propertyDictionary setObject:@"id" forKey:propertyName];
            } else {
                [propertyDictionary setObject:@"unknow" forKey:propertyName];
                NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Reflection get property type> \r\n Unknow type %s in class %s \r\n -------- \r\n\r\n", rawPropertyType, class_getName(class));
            }
        }
    }
    free(properties);
    return propertyDictionary;
}
+ (NSDictionary*) A_PropertiesFromObject: (id)obj {
    return [self A_PropertiesFromClass:[self A_GetClass:obj]];
}

+ (NSArray *)A_PropertieNamesFromClass: (Class)class{
    return [[self A_PropertiesFromClass:class] allKeys];
}
+ (NSArray *)A_PropertieNamesFromObject: (id)obj{
    return [[self A_PropertiesFromObject:obj] allKeys];
}

+ (NSObject*)A_CreateObject: (NSString*) className {
    return [[NSClassFromString(className) alloc] init];
}

@end
