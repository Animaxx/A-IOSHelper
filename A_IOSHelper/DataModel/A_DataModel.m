//
//  A_DataModel.m
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_DataModel.h"
#import "A_Reflection.h"
#import "A_JSONHelper.h"

@implementation A_DataModel

- (NSDictionary*)A_Serialize {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSArray *propertyList = [A_Reflection A_PropertieNamesFromObject:self];
    for (NSString *key in propertyList) {
        id value = [self valueForKey:key];
        
        if (value == nil) {
            value = [NSNull null];
        }
        [dict setObject:value forKey:key];
    }
    return dict;
}
+ (NSObject*)A_Deserialize: (NSDictionary*)Array {
    id obj = [[[self class] alloc] init];
    
    for (NSString *key in [Array allKeys]) {
        [obj setValue:[Array objectForKey:key] forKey:key];
    }
    
    return obj;
}

- (NSString*)A_ConvertToJSON {
    NSDictionary* _dic = [self A_Serialize];
    
    return [A_JSONHelper A_ConvertDictionaryToJSON:_dic];
}
+ (NSObject*)A_ConvertFromJSON: (NSString*)JSON {
    NSDictionary* _dic = [A_JSONHelper A_ConvertJSONToDictionary:JSON];
    return [self A_Deserialize:_dic];
}


@end
