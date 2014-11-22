//
//  A_JSONHelper.m
//  A-IOSHelper
//
//  Created by Animax on 11/21/14.
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import "A_JSONHelper.h"

@implementation A_JSONHelper

+ (NSDictionary*)A_ConvertJSONToDictionary: (NSString*)JSONStr{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: [JSONStr dataUsingEncoding:NSUTF8StringEncoding]
                                                        options: NSJSONReadingMutableContainers
                                                          error: &error];
    if (!dic) {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <JSON to Dictionary error>  \r\n %@", error);
#endif
        return nil;
    } else {
        return dic;
    }
}
+ (NSArray*)A_ConvertJSONToArray: (NSString*)JSONStr{
    NSError *error = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData: [JSONStr dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
    if (!arr) {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <JSON to Array error>  \r\n %@", error);
#endif
        return nil;
    } else {
        return arr;
    }
}

+ (NSString*)A_ConvertDictionaryToJSON: (NSDictionary*)Dict{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: Dict
                                                       options: 0
                                                         error: &error];
    if (!jsonData) {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Dictionary to JSON error>  \r\n %@", error);
#endif
        return nil;
    } else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        return JSONString;
    }
}
+ (NSString*)A_ConvertArrayToJSON: (NSArray*)Arr{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: Arr
                                                       options: 0
                                                         error: &error];
    if (!jsonData) {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Array to JSON error>  \r\n %@", error);
#endif
        return nil;
    } else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        return JSONString;
    }
}

+ (NSData*)A_ConvertDictionaryToData: (NSDictionary*)Dict{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: Dict
                                                       options: 0
                                                         error: &error];
    if (!jsonData) {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Dictionary to Data error>  \r\n %@", error);
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
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Array to Data error>  \r\n %@", error);
#endif
        return nil;
    } else {
        return jsonData;
    }
}

@end
