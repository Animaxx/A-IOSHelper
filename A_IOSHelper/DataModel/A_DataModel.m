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
#import "A_PlistHelper.h"
#import "A_TaskHelper.h"
#import "NSObject+A_KVO_Extension.h"

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
    NSDictionary *_dic = [self A_Serialize];
    
    return [A_JSONHelper A_ConvertDictionaryToJSON:_dic];
}
+ (NSObject*)A_ConvertFromJSON: (NSString*)JSON {
    NSDictionary *_dic = [A_JSONHelper A_ConvertJSONToDictionary:JSON];
    return [self A_Deserialize:_dic];
}

- (void)A_SaveToPlist {
    NSString *_className = [A_Reflection A_GetClassNameFromObject:self];
    NSString *_objKey = [NSString stringWithFormat:@"A_%@_key",_className];
    
    NSMutableArray *_list = [A_PlistHelper A_GetByGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
    if (!_list || ![_list isKindOfClass:[NSMutableArray class]]) {
        _list = [[NSMutableArray alloc] init];
    }
    
    [_list addObject:self];
    [A_PlistHelper A_Save:_list toGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
}
- (void)A_DeleteInPlist {
    NSString *_className = [A_Reflection A_GetClassNameFromObject:self];
    NSString *_objKey = [NSString stringWithFormat:@"A_%@_key",_className];
    
    NSMutableArray *_list = [A_PlistHelper A_GetByGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
    if (!_list || ![_list isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    for (int i=0; i<[_list count]; i++) {
        if ([[[_list objectAtIndex:i] A_ConvertToJSON] isEqualToString:[self A_ConvertToJSON]]) {
            [_list removeObjectAtIndex:i];
            break;
        }
    }
    
    [A_PlistHelper A_Save:_list toGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
}
+ (NSArray*)A_GetFromPliste {
    NSString *_className = [A_Reflection A_GetClassNameFromObject:self];
    NSString *_objKey = [NSString stringWithFormat:@"A_%@_key",_className];
    
    NSMutableArray *_list = [A_PlistHelper A_GetByGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
    if (!_list || ![_list isKindOfClass:[NSMutableArray class]]) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}
+ (void)A_ClearFromPlist {
    NSString *_className = [A_Reflection A_GetClassNameFromObject:self];
    NSString *_objKey = [NSString stringWithFormat:@"A_%@_key",_className];
    
    NSMutableArray *_list = _list = [[NSMutableArray alloc] init];
    [A_PlistHelper A_Save:_list toGroup:DATAMODEL_STORE_GROUP andKey:_objKey];
}

- (A_SqliteManager *)__sqliteManager {
    A_DataModelDBIdentity *dbID = [self databaseIdentity];
    return [A_SqliteManager A_Instance:dbID];
}

+ (BOOL)A_CompleteMissingFieldsInSqlite {
    A_DataModel *instanceObj = (A_DataModel *)[[[self class] alloc] init];
    A_SqliteManager *manager = [instanceObj __sqliteManager];
    
    if (![manager A_TableExist:[A_SqliteManager A_GenerateTableName:instanceObj]]) {
        [manager A_CreateTable:instanceObj AndKey:[instanceObj tablePrimaryKey]];
        return YES;
    } else {
        return [manager A_CompleteMissingFields:instanceObj WithIgnore:[instanceObj __gnereateIgnoreKeys]];
    }
}

- (NSArray<NSString *> *)__gnereateIgnoreKeys {
    NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[self tableIgnoreFields]];
    [keys addObject:[self tablePrimaryKey]];
    return keys;
}
- (NSNumber *)A_SaveToSqlite {
    A_SqliteManager *manager = [self __sqliteManager];
    
    if (![manager A_TableExist:[A_SqliteManager A_GenerateTableName:self]]) {
        [manager A_CreateTable:self AndKey:[self tablePrimaryKey]];
    }
    
    NSNumber *effectRows = [manager A_Update:self AndKeys:@[[self tablePrimaryKey]]];
    if ([effectRows integerValue] <= 0) {
        return [self A_InsertToSqlite];
    } else {
        id kv = [self valueForKeyPath:[self tablePrimaryKey]];
        if (kv) {
            if ([kv isKindOfClass:[NSNumber class]]) {
                return (NSNumber*)kv;
            }
        }
        
        return effectRows;
    }
}
- (NSNumber *)A_InsertToSqlite {
    A_SqliteManager *manager = [A_SqliteManager A_Instance];
    
    if (![manager A_TableExist:[A_SqliteManager A_GenerateTableName:self]]) {
        [manager A_CreateTable:self];
    }
    
    [manager A_Insert:self WithIgnore:[self __gnereateIgnoreKeys]];
    NSNumber *lastID = [manager A_lastInsertId];
    
    [self setValue:lastID forKeyPath:[self tablePrimaryKey]];
    return lastID;
}
- (void)A_DeleteModelInSqlite {
    NSNumber *result = [[self __sqliteManager] A_Delete:self];
    NSLog(@"%@", result);
}
- (void)A_DeleteModelInSqliteWithKeys: (NSArray<NSString *> *)tableKeys {
    NSNumber *result = [[self __sqliteManager] A_Delete:self AndKeys:tableKeys];
    NSLog(@"%@", result);
}
- (nonnull NSArray*)A_SearchSimilarModelsInSqlite {
    return [[self __sqliteManager] A_SearchSimilarModels:self];
}
+ (nonnull NSArray*)A_SearchSqlite: (NSString*)where {
    id obj = [[[self class] alloc] init];
    A_SqliteManager *manager = nil;
    if ([obj isKindOfClass:[A_DataModel class]]) {
        manager = [(A_DataModel*)obj __sqliteManager];
    } else {
        manager = [A_SqliteManager A_Instance];
    }
    
    return [manager A_SearchModels:[self class] Where:where];
}

- (void)A_SearchSimilarModelsInSqliteWithBlock:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj{
    if (!obj) {
        obj = [NSNull null];
    }
    
    [A_TaskHelper A_RunInBackgroundWithParam:@[self,obj] Block:^(id arg) {
        NSArray *result = [[A_SqliteManager A_Instance] A_SearchSimilarModels:[arg objectAtIndex:0]];
        id _arg = [arg objectAtIndex:1];
        if (_arg == [NSNull null]) {
            _arg = nil;
        }
        finishBlock(_arg, result);
    }];
}
+ (void)A_SearchSqlite: (NSString*)where withBlock:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj{
    if (!obj) {
        obj = [NSNull null];
    }
    
    id instance = [[[self class] alloc] init];
    A_SqliteManager *manager = nil;
    if ([obj isKindOfClass:[A_DataModel class]]) {
        manager = [(A_DataModel*)instance __sqliteManager];
    } else {
        manager = [A_SqliteManager A_Instance];
    }
    
    [A_TaskHelper A_RunInBackgroundWithParam:@[self,where,obj] Block:^(id arg) {
        NSArray *result = [manager A_SearchModels:[[arg objectAtIndex:0] class] Where:[arg objectAtIndex:1]];
        id _arg = [arg objectAtIndex:1];
        if (_arg == [NSNull null]) {
            _arg = nil;
        }
        finishBlock(_arg, result);
    }];
}

#pragma mark - Override
- (A_DataModelDBIdentity *)databaseIdentity {
    return [[A_DataModelDBIdentity alloc] init];
}
- (NSString *)tablePrimaryKey {
    return @"id";
}
- (NSArray<NSString *> *)tableIgnoreFields {
    return @[];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSDictionary *_dic = [self A_Serialize];
    
    for (NSString *key in _dic) {
        [encoder encodeObject:[_dic objectForKey:key] forKey:key];
    }
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [self init]) {
        NSArray *_keys = [A_Reflection A_PropertieNamesFromObject:self];
        
        for (NSString *key in _keys) {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

#pragma mark -

@end
