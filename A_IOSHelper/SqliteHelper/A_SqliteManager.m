//
//  A_SqliteWrapper.m
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//
#define DEFAULT_SQLITE_NAME @"A_SQLITE_FILE.DB"

#import "A_SqliteManager.h"
#import <sqlite3.h>
#import "A_Reflection.h"

@implementation A_SqliteManager

sqlite3 *database;
sqlite3_stmt *statement;
NSString *databaseFileName;
NSFileManager *filemanager;
NSMutableArray *ExistingTables;

#pragma mark - Database Operation


+ (A_SqliteManager *) A_Instance {
    return [A_SqliteManager A_Instance:DEFAULT_SQLITE_NAME];
}
+ (A_SqliteManager *) A_Instance: (NSString *)file {
    static dispatch_once_t pred = 0;
    __strong static NSMutableDictionary* _storage = nil;
    dispatch_once(&pred, ^{
        _storage = [[NSMutableDictionary alloc] init];
    });
    if (![_storage objectForKey:file] || [_storage objectForKey:file] == nil) {
        [_storage setObject:[[A_SqliteManager alloc] init:file] forKey:file];
    }
    
    return [_storage objectForKey:file];
}

- (id) init{
    return [self init:DEFAULT_SQLITE_NAME];
}
- (id) init: (NSString *)file {
    if ((self = [super init])) {
        databaseFileName = file;
        [self A_OpenConnetion];
    }
    return self;
}

- (BOOL) A_IsOpened {
    return database!=nil;
}
- (void) A_OpenConnetion {
    if (database) return;
    
    filemanager = [[NSFileManager alloc] init];
    NSString * dbpath = [self A_DBPath];
    
    if (![filemanager fileExistsAtPath:dbpath]) {
        NSString * defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseFileName];
        if ([filemanager fileExistsAtPath:defaultDBPath]) {
            [filemanager copyItemAtPath:defaultDBPath toPath:dbpath error:NULL];
        }
    }
    if (sqlite3_open([dbpath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Initialize Database: could not open database (%s)", sqlite3_errmsg(database));
    }
    filemanager = nil;
}
- (void) A_CloseConnetion {
    if (database) sqlite3_close(database);
    database = nil;
    filemanager = nil;
}
- (void) dealloc {
    [self A_CloseConnetion];
}

- (NSString *) A_DBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return [documentsDirectory stringByAppendingPathComponent:databaseFileName];
}

#pragma mark - SQL Queries

- (NSNumber *) A_ExecuteQuery:(NSString *) query {
    return [self A_ExecuteQuery:query withArgs:nil];
}
- (NSNumber *) A_ExecuteQuery:(NSString *) query withArgs:(NSArray*) args {
    [self _bindSQL:[query UTF8String] withArray:args];
    if (statement == NULL) return @0;
    
    sqlite3_step(statement);
    if(sqlite3_finalize(statement) == SQLITE_OK) {
        return @(sqlite3_changes(database));
    } else {
        return @0;
    }
}

- (NSArray*) A_SearchDataset:(NSString *) query {
    return [self A_SearchDataset:query withParams:nil];
}
- (NSArray*) A_SearchDataset:(NSString *) query withParams:(NSArray*) params {
    [self _bindSQL:[query UTF8String] withArray:params];
    if (statement == NULL) return [[NSArray alloc] init];
    
    NSMutableArray* dataset = [[NSMutableArray alloc] init];
    NSDictionary * row = nil;
    while ((row = [self _getRow])) {
        [dataset addObject:row];
    }
    
    return dataset;
}

- (NSDictionary*) _getRow {
    int rc = sqlite3_step(statement);
    if (rc == SQLITE_DONE) {
        sqlite3_finalize(statement);
        return nil;
    } else  if (rc == SQLITE_ROW) {
        int col_count = sqlite3_column_count(statement);
        if (col_count >= 1) {
            NSMutableDictionary * dRow = [NSMutableDictionary dictionaryWithCapacity:col_count];
            for(int i = 0; i < col_count; i++) {
                dRow[ @(sqlite3_column_name(statement, i)) ] = [self _columnValue:i];
            }
            return dRow;
        }
    } else {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Can not get row %s", sqlite3_errmsg(database));
#endif
        return nil;
    }
    return nil;
}

- (id) A_GetValueFromQuery:(NSString *) query {
    return [self A_GetValueFromQuery:query withParams:nil];
}
- (id) A_GetValueFromQuery:(NSString *) query withParams:(NSArray*) params {
    [self _bindSQL:[query UTF8String] withArray:params];
    if (statement == NULL) return nil;
    
    int rc = sqlite3_step(statement);
    if (rc == SQLITE_DONE) {
        sqlite3_finalize(statement);
        return nil;
    } else  if (rc == SQLITE_ROW) {
        int col_count = sqlite3_column_count(statement);
        if (col_count < 1) return nil;
        id o = [self _columnValue:0];
        sqlite3_finalize(statement);
        return o;
    } else {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Can not get row %s", sqlite3_errmsg(database));
#endif
        return nil;
    }
}

- (void) _bindSQL:(const char *) cQuery withArray:(NSArray *) params {
    NSInteger param_count;
    
    if (sqlite3_prepare_v2(database, cQuery, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Statement exception (%s) %s", sqlite3_errmsg(database), cQuery);
        statement = NULL;
        return;
    }
    
    param_count = sqlite3_bind_parameter_count(statement);
    if (param_count != [params count]) {
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Parameters exception (%s)", cQuery);
        statement = NULL;
        return;
    }
    
    if (param_count) {
        for (int i = 0; i < param_count; i++) {
            id o = params[i];
            
            // determine the type of the parameter
            if ([o isEqual:[NSNull null]]) {
                sqlite3_bind_null(statement, i + 1);
            } else if ([o respondsToSelector:@selector(objCType)]) {
                if (strchr("islqISLBQ", *[o objCType])) { // integer
                    sqlite3_bind_int(statement, i + 1, [o intValue]);
                } else if (strchr("fd", *[o objCType])) {   // double
                    sqlite3_bind_double(statement, i + 1, [o doubleValue]);
                } else {    // unhandled types
                    NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Unhandled ObjCType: %s query: %s", [o objCType], cQuery);
                    statement = NULL;
                    return;
                }
            } else if ([o isKindOfClass:[NSString class]]) { // string
                sqlite3_bind_text(statement, i + 1, [o UTF8String], -1, SQLITE_TRANSIENT);
            } else {    // unhhandled type
                NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Unhandled parameter type: %@ query: %s", [o class], cQuery);
                statement = NULL;
                return;
            }
        }
    }
    return;
}

- (Boolean) A_TableExist:(NSString*) tableName {
    if (ExistingTables && [ExistingTables containsObject:tableName]) {
        return YES;
    } else {
        id _result = [self A_GetValueFromQuery:@"SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = ?" withParams:@[tableName]];
        if (_result && [[_result class] isSubclassOfClass:[NSNumber class]]) {
            if (!ExistingTables) {
                ExistingTables = [[NSMutableArray alloc] init];
            }
            [ExistingTables addObject:tableName];
            return [((NSNumber*)_result) intValue] > 0;
        } else {
            return NO;
        }
    }
}

#pragma mark - Data Model Methods
- (NSString*) _nameOfType:(NSString*)type {
    if ([type isEqualToString:@"BOOL"] ||
        [type isEqualToString:@"bool"]) {
        return @"BOOLEAN";
    } else if ([type isEqualToString:@"char"] ||
               [type isEqualToString:@"NSString"]) {
        return @"TEXT";
    } else if ([type isEqualToString:@"short"] ||
               [type isEqualToString:@"long"] ||
               [type isEqualToString:@"int"] ||
               [type isEqualToString:@"NSInteger"]) {
        return @"INTEGER";
    } else if ([type isEqualToString:@"float"] ||
               [type isEqualToString:@"double"] ||
               [type isEqualToString:@"NSNumber"]) {
        return @"REAL";
    } else if ([type isEqualToString:@"NSDate"]) {
        return @"DATETIME";
    } else if ([type isEqualToString:@"id"] ||
               [type isEqualToString:@"NSData"]) {
        return @"REAL";
    }
    
    NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQLite Manager> \r\n Unknow Type: %@", type);
    return @"REAL";
}

- (Boolean) A_TableColumnMarch:(A_DataModel*) model {
    NSLog(@"TODO");
    return YES;
}
- (NSString*) A_GenerateTableName: (A_DataModel*) model {
    NSString* _className = [A_Reflection A_GetClassNameFromObject:model];
    return [NSString stringWithFormat:@"A_%@_table",_className];
}

- (NSString*) A_CreateTableScript:(A_DataModel*) model {
    return [self A_CreateTableScript:model WithTableName:[self A_GenerateTableName:model] AndKey:nil];
}
- (NSString*) A_CreateTableScript:(A_DataModel*) model AndKey:(NSString*)key{
    return [self A_CreateTableScript:model WithTableName:[self A_GenerateTableName:model] AndKey:key];
}
- (NSString*) A_CreateTableScript:(A_DataModel*) model WithTableName:(NSString*)tableName AndKey:(NSString*)key{
    NSDictionary* properties = [A_Reflection A_PropertiesFromObject:model];
    
    NSString* _createTableSql = [NSString stringWithFormat:@"CREATE TABLE \"%@\" (", tableName];
    
    BOOL _first = YES;
    NSString* _format;
    NSString* _type;
    for (NSString* propertyName in properties) {
        if (_first) {
            _format = @"\"%@\" %@";
        } else {
            _format = @", \"%@\" %@";
        }
        
        _type = [self _nameOfType:[properties objectForKey:propertyName]];
        
        if (key && key.length > 0 && [[propertyName lowercaseString] isEqualToString:[key lowercaseString]]) {
            _format = [_format stringByAppendingString:@" NOT NULL PRIMARY KEY"];
            if ([_type isEqualToString:@"INTEGER"]) {
                _format = [_format stringByAppendingString:@" AUTOINCREMENT"];
            }
        }
        
        _createTableSql = [_createTableSql stringByAppendingFormat:_format, propertyName, _type];
        
        _first = NO;
    }
    _createTableSql = [_createTableSql stringByAppendingString:@")"];
    return _createTableSql;
}

- (NSNumber*) A_ExecuteTableCreate:(A_DataModel*) model {
    NSString* _sql = [self A_CreateTableScript:model];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteTableCreate:(A_DataModel*) model AndKey:(NSString*)key {
    NSString* _sql = [self A_CreateTableScript:model AndKey:key];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteTableCreate:(A_DataModel*) model WithTableName:(NSString*)tableName AndKey:(NSString*)key {
    NSString* _sql = [self A_CreateTableScript:model WithTableName:tableName AndKey:key];
    return [self A_ExecuteQuery:_sql];
}

- (NSString*) A_CreateInsertScript:(A_DataModel*) model {
    return [self A_CreateInsertScript:model WithIgnore:nil AndTable:[self A_GenerateTableName:model]];
}
- (NSString*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)keys {
    return [self A_CreateInsertScript:model WithIgnore:keys AndTable:[self A_GenerateTableName:model]];
}
- (NSString*) A_CreateInsertScript:(A_DataModel*) model WithTable:(NSString*)tableName {
    return [self A_CreateInsertScript:model WithIgnore:nil AndTable:tableName];
}
- (NSString*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys AndTable:(NSString*)tableName {
    NSDictionary* properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray* _keys = [properties allKeys];
    
    BOOL _firstVal = YES;
    BOOL _ignore = NO;
    NSString* _valuesStr = [[NSString alloc] init];
    NSString* _keysStr = [[NSString alloc] init];
    
    for (NSString* item in _keys) {
        _ignore = NO;
        for (NSString* _ignoreKey in ignoreKeys) {
            if ([[item lowercaseString] isEqualToString:[_ignoreKey lowercaseString]]) {
                _ignore = YES;
                break;
            }
        }
        if (_ignore) continue;
        
        if (_firstVal) {
            _keysStr = [_keysStr stringByAppendingFormat: @"`%@`", item];
            _valuesStr = [_valuesStr stringByAppendingFormat: @"'%@'", [model valueForKey:item]];
        } else {
            _keysStr = [_keysStr stringByAppendingFormat: @",`%@`", item];
            _valuesStr = [_valuesStr stringByAppendingFormat: @",'%@'", [model valueForKey:item]];
        }
        _firstVal = NO;
    }
    
    NSString* _insterTableSql = [NSString stringWithFormat:@"INSERT INTO \"%@\" (%@) VALUES (%@)", tableName, _keysStr, _valuesStr];
    
    return _insterTableSql;
}

- (NSNumber*) A_ExecuteInsert: (A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys AndTable:(NSString*)tableName{
    NSString* _sql = [self A_CreateInsertScript:model WithIgnore:ignoreKeys AndTable:tableName];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteInsert: (A_DataModel*) model WithTable:(NSString*)tableName{
    NSString* _sql = [self A_CreateInsertScript:model WithTable:tableName];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteInsert: (A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys{
    NSString* _sql = [self A_CreateInsertScript:model WithIgnore:ignoreKeys];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteInsert: (A_DataModel*) model{
    NSString* _sql = [self A_CreateInsertScript:model];
    return [self A_ExecuteQuery:_sql];
}

- (NSString*) A_CreateUpdateScript:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    NSDictionary* properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray* _keys = [properties allKeys];
    
    NSString* _valuesStr = [[NSString alloc] init];
    NSString* _keysStr = [[NSString alloc] init];
    
    BOOL _isKey = NO;
    for (NSString* item in _keys) {
        _isKey = NO;
        for (NSString* _keys in keys) {
            if ([[item lowercaseString] isEqualToString:[_keys lowercaseString]]) {
                if (_keysStr.length == 0) {
                    _keysStr = [_keysStr stringByAppendingFormat: @" `%@` = '%@'", item, [model valueForKey:item]];
                } else {
                    _keysStr = [_keysStr stringByAppendingFormat: @" AND `%@` = '%@'", item, [model valueForKey:item]];
                }
                _isKey = YES;
                break;
            }
        }
        
        if (!_isKey) {
            if (_valuesStr.length == 0) {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" `%@` = '%@'", item, [model valueForKey:item]];
            } else {
                _valuesStr = [_valuesStr stringByAppendingFormat: @", `%@` = '%@'", item, [model valueForKey:item]];
            }
        }
    }
    
    NSString* _sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,_valuesStr, _keysStr];
    return _sql;
}
- (NSString*) A_CreateUpdateScript:(A_DataModel*) model AndKeys:(NSArray*)keys {
    return [self A_CreateUpdateScript:model WithTable:[self A_GenerateTableName:model] AndKeys:keys];
}

- (NSNumber*) A_ExecuteUpdate:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    NSString* _sql = [self A_CreateUpdateScript:model WithTable:tableName AndKeys:keys];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteUpdate:(A_DataModel*) model AndKeys:(NSArray*)keys {
    NSString* _sql = [self A_CreateUpdateScript:model AndKeys:keys];
    return [self A_ExecuteQuery:_sql];
}

- (NSString*) A_CreateDeleteScript:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    NSDictionary* properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray* _keys = [properties allKeys];
    
    NSString* _valuesStr = [[NSString alloc] init];
    
    BOOL _isKey = NO;
    for (NSString* item in _keys) {
        if (keys) {
        _isKey = NO;
            for (NSString* _keys in keys) {
                if ([[item lowercaseString] isEqualToString:[_keys lowercaseString]]) {
                    _isKey = YES;
                }
            }
        } else {
            _isKey = YES;
        }
        
        if (_isKey) {
            if (_valuesStr.length == 0) {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" `%@` = '%@'", item, [model valueForKey:item]];
            } else {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" AND `%@` = '%@'", item, [model valueForKey:item]];
            }
        }

    }
    
    NSString* _sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,_valuesStr];
    
    return _sql;
}
- (NSString*) A_CreateDeleteScript:(A_DataModel*) model WithTable:(NSString*)tableName {
    return [self A_CreateDeleteScript:model WithTable:tableName AndKeys:nil];
}
- (NSString*) A_CreateDeleteScript:(A_DataModel*) model AndKeys:(NSArray*)keys {
    return [self A_CreateDeleteScript:model WithTable:[self A_GenerateTableName:model] AndKeys:keys];
}
- (NSString*) A_CreateDeleteScript:(A_DataModel*) model {
    return [self A_CreateDeleteScript:model WithTable:[self A_GenerateTableName:model] AndKeys:nil];
}

- (NSNumber*) A_ExecuteDelete:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    NSString* _sql = [self A_CreateDeleteScript:model WithTable:tableName AndKeys:keys];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteDelete:(A_DataModel*) model WithTable:(NSString*)tableName {
    NSString* _sql = [self A_CreateDeleteScript:model WithTable:tableName];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteDelete:(A_DataModel*) model AndKeys:(NSArray*)keys {
    NSString* _sql = [self A_CreateDeleteScript:model AndKeys:keys];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_ExecuteDelete:(A_DataModel*) model {
    NSString* _sql = [self A_CreateDeleteScript:model];
    return [self A_ExecuteQuery:_sql];
}

- (NSArray*) A_SearchSimilarModels:(A_DataModel*) model {
    return [self A_SearchSimilarModels:model WithTable:[self A_GenerateTableName:model]];
}
- (NSArray*) A_SearchSimilarModels:(A_DataModel*) model WithTable:(NSString*)tableName {
    NSDictionary* properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray* _keys = [properties allKeys];
    
    NSString* _valuesStr = [[NSString alloc] init];
    for (NSString* item in _keys) {
        id _value = [model valueForKey:item];
        
        if (_value && _value != nil && _value != NULL && _value != [NSNull null] &&
            ([_value isMemberOfClass:[NSNumber class]] && [NSNumber numberWithBool:0] != _value && [NSNumber numberWithChar:0] != _value &&[NSNumber numberWithDouble:0] != _value &&[NSNumber numberWithFloat:0] != _value &&[NSNumber numberWithInt:0] != _value &&[NSNumber numberWithInteger:0] != _value &&[NSNumber numberWithLong:0] != _value &&[NSNumber numberWithLongLong:0] != _value &&[NSNumber numberWithShort:0] != _value) &&
            ([_value isMemberOfClass:[NSString class]] && ![_value isEqualToString:@""])) {
            
            if (_valuesStr.length == 0) {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" `%@` = '%@'", item, [model valueForKey:item]];
            } else {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" AND `%@` = '%@'", item, [model valueForKey:item]];
            }
        }
    }
    
    NSString* _sql;
    if (_valuesStr.length == 0)
        _sql = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
    else
        _sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@",tableName,_valuesStr];
    
    NSArray* _result = [self A_SearchDataset:_sql];
    return [self A_Mapping:_result ToClass:[A_Reflection A_GetClass:model]];
}
- (NSArray*) A_SearchModels:(Class)class Where:(NSString*)query WithTable:(NSString*)tableName {
    NSString* _sql;
    if (query.length == 0)
        _sql = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
    else
        _sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@",tableName,query];
    
    NSArray* _result = [self A_SearchDataset:_sql];
    return [self A_Mapping:_result ToClass:class];
}
- (NSArray*) A_SearchModels:(Class)class Where:(NSString*)query{
    NSString* _tableName = [NSString stringWithFormat:@"A_%@_table",NSStringFromClass(class)];
    return [self A_SearchModels:class Where:query WithTable:_tableName];
}




#pragma mark - Utility Methods

- (id) _columnValue:(int) columnIndex {
    id o = nil;
    switch(sqlite3_column_type(statement, columnIndex)) {
        case SQLITE_INTEGER:
            o = @(sqlite3_column_int(statement, columnIndex));
            break;
        case SQLITE_FLOAT:
            o = [NSNumber numberWithFloat:sqlite3_column_double(statement, columnIndex)];
            break;
        case SQLITE_TEXT:
            o = @((const char *) sqlite3_column_text(statement, columnIndex));
            break;
        case SQLITE_BLOB:
            o = [NSData dataWithBytes:sqlite3_column_blob(statement, columnIndex) length:sqlite3_column_bytes(statement, columnIndex)];
            break;
        case SQLITE_NULL:
            o = [NSNull null];
            break;
    }
    return o;
}

- (NSNumber *) A_lastInsertId {
    return [NSNumber numberWithLongLong:sqlite3_last_insert_rowid(database)];
}

- (NSArray*) A_Mapping:(NSArray*) data ToClass:(Class)class{
    NSMutableArray* _array = [[NSMutableArray alloc] init];
    
    @try {
        for (NSDictionary* dic in data) {
            id obj = [[class alloc] init];
            for (NSString *key in dic) {
                [obj setValue:[dic objectForKey:key] forKey:key];
            }
            [_array addObject:obj];
        }
    }
    @catch (NSException* e) {
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Mapping ERROR (%@)", e.reason);
    }
    
    return _array;
}

@end
