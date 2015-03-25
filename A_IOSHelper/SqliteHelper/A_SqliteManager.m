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

#pragma mark - Database Operation

+ (A_SqliteManager *) A_Init {
    return [[A_SqliteManager alloc] init];
}
+ (A_SqliteManager *) A_Init: (NSString *)file {
    return [[A_SqliteManager alloc] init: file];
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

- (NSArray*) A_SearchForDataset:(NSString *) query {
    return [self A_SearchForDataset:query withParams:nil];
}
- (NSArray*) A_SearchForDataset:(NSString *) query withParams:(NSArray*) params {
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
    id _result = [self A_GetValueFromQuery:@"SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = '?'" withParams:@[tableName]];
    return (NSInteger)_result > 0;
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
        
        if (tableName && tableName.length > 0 && [[propertyName lowercaseString] isEqualToString:[tableName lowercaseString]]) {
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
    NSString* _createTableSql = [NSString stringWithFormat:@"INSERT INTO \"%@\" (\"", tableName];
    _createTableSql = [_createTableSql stringByAppendingString: [_keys componentsJoinedByString:@"\",\""]];
    _createTableSql = [_createTableSql stringByAppendingString: @") values ("];
    
    BOOL _firstVal = YES;
    for (NSString* item in _keys) {        
//        [ignoreKeys indexOfObject:<#(id)#>]
        
        if (_firstVal) {
            _createTableSql = [_createTableSql stringByAppendingFormat: @"'%@'", [model valueForKey:item]];
        } else {
            _createTableSql = [_createTableSql stringByAppendingFormat: @",'%@'", [model valueForKey:item]];
        }
        _firstVal = NO;
    }
    
    _createTableSql = [_createTableSql stringByAppendingString: @")"];
    return _createTableSql;
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


@end
