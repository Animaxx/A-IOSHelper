//
//  A_JSONHelper.m
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import "A_JSONHelper.h"
#import "NSDate+A_Extension.h"

@implementation A_JSONHelper

+ (NSDictionary*)_tidyDict: (NSDictionary*) _dict {
    NSMutableDictionary *_tidyDict = [[NSMutableDictionary alloc] init];
    for (id key in [_dict allKeys]) {
        id value = [_dict objectForKey:key];
        id _key = key;
        if ([_key isKindOfClass:[NSDate class]]) {
            _key = [(NSDate *)_key A_FormatToDetailString];
        }
        
        if ([value isKindOfClass:[NSDate class]]) {
            [_tidyDict setValue:[(NSDate *)value A_FormatToDetailString] forKey:_key];
        }else if ([value isKindOfClass:[NSArray class]]) {
            [_tidyDict setValue:[A_JSONHelper _tidyArr:(NSArray *)value] forKey:_key];
        }else if ([value isKindOfClass:[NSDictionary class]]) {
            [_tidyDict setValue:[A_JSONHelper _tidyDict:(NSDictionary *)value] forKey:_key];
        }else {
            [_tidyDict setValue:value forKey:_key];
        }
    }
    return _tidyDict;
}
+ (NSArray*)_tidyArr: (NSArray*) _arr {
    NSMutableArray *_tidyArr = [[NSMutableArray alloc] init];
    for (id _obj in _arr) {
        if ([_obj isKindOfClass:[NSDate class]]) {
            [_tidyArr addObject:[(NSDate *)_obj A_FormatToDetailString]];
        }else if ([_obj isKindOfClass:[NSArray class]]) {
            [_tidyArr addObject:[A_JSONHelper _tidyArr:(NSArray *)_obj]];
        }else if ([_obj isKindOfClass:[NSDictionary class]]) {
            [_tidyArr addObject:[A_JSONHelper _tidyDict:(NSDictionary *)_obj]];
        }else {
            [_tidyArr addObject:_obj];
        }
    }
    return _tidyArr;
}

+ (id)A_ConvertJSONToArrayOrDictionary: (NSString*)JSONStr{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData: [JSONStr dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &error];
    if (!result) return nil;
    else {
        
        return result;
    }
}

+ (NSDictionary*)A_ConvertJSONToDictionary: (NSString*)JSONStr{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: [JSONStr dataUsingEncoding:NSUTF8StringEncoding]
                                                        options: NSJSONReadingMutableContainers
                                                          error: &error];
    if (!dic) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <JSON to Dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        return [[A_Dictionary alloc] initWithDictionary:dic];
    }
}
+ (NSArray*)A_ConvertJSONToArray: (NSString*)JSONStr{
    NSError *error = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData: [JSONStr dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
    if (!arr) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <JSON to Array error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        return arr;
    }
}

+ (NSString*)A_ConvertDictionaryToJSON: (NSDictionary*)Dict{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: [self _tidyDict: Dict]
                                                       options: 0
                                                         error: &error];
    if (!jsonData) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Dictionary to JSON error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        return JSONString;
    }
}
+ (NSString*)A_ConvertArrayToJSON: (NSArray*)Arr{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: [self _tidyArr: Arr]
                                                       options: 0
                                                         error: &error];
    if (!jsonData) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Array to JSON error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        return JSONString;
    }
}

+ (NSData*)A_ConvertDictionaryToData: (NSDictionary*)Dict{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: [self _tidyDict: Dict]
                                                       options: 0
                                                         error: &error];
    if (!jsonData) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Dictionary to Data error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        return jsonData;
    }
}
+ (NSData*)A_ConvertArrayToData: (NSArray*)Arr{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: Arr
                                                       options: 0
                                                         error: &error];
    if (!jsonData) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Array to Data error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        return jsonData;
    }
}

+ (NSDictionary*)A_ConvertJSONDataToDictionary: (NSData*)JSONData {
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: JSONData
                                                        options: NSJSONReadingMutableContainers
                                                          error: &error];
    if (!dic) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <JSON Data to Dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        return [[A_Dictionary alloc] initWithDictionary:dic];
    }
}
+ (NSArray*)A_ConvertJSONDataToArray: (NSData*)JSONData {
    NSError *error = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData: JSONData
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
    if (!arr) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <JSON Data to Array error>  \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    } else {
        return arr;
    }
}



@end
