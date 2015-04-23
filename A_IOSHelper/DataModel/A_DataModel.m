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
#import "A_UserDatafileHelper.h"

#define DATAMODEL_STORE_GROUP @"A_DATAMODEL_GROUP"

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

- (void)A_SaveToUserfile {
    NSString* _className = [A_Reflection A_GetClassNameFromObject:self];
    NSString* _objKey = [NSString stringWithFormat:@"A_%@_key",_className];
    
    NSMutableArray* _list = [A_UserDatafileHelper A_GetByGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
    if (!_list || ![_list isKindOfClass:[NSMutableArray class]]) {
        _list = [[NSMutableArray alloc] init];
    }
    
    [_list addObject:self];
    [A_UserDatafileHelper A_Save:_list toGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSDictionary* _dic = [self A_Serialize];
    
    for (NSString *key in _dic) {
        [encoder encodeObject:[_dic objectForKey:key] forKey:key];
    }
}
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [self init]) {
        NSArray* _keys = [A_Reflection A_PropertieNamesFromObject:self];
        
        for (NSString *key in _keys) {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
        }
    }
	return self;
}

#pragma mark -

@end
