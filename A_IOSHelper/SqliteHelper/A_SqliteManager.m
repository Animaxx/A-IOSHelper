//
//  A_SqliteWrapper.m
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//
#define DEFAULT_SQLITE_NAME @"DATABASE_STORE.DB"

#import "A_SqliteManager.h"
#import <sqlite3.h>
#import "A_Reflection.h"
#import "A_TaskHelper.h"
#import "NSDate+A_Extension.h"
#import "A_DataModel.h"
#import "NSArray+A_Extension.h"
#import "NSMutableArray+A_Extension.h"

@implementation A_DataModelDBIdentity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.DatabaseIdentity = DEFAULT_SQLITE_NAME;
        self.SharedGroupName = nil;
        self.StoringType = A_SqliteStoringInLibraryFolder;
    }
    return self;
}
- (instancetype)initWithIdentity:(NSString *)databaseIdentity
{
    self = [super init];
    if (self) {
        self.DatabaseIdentity = databaseIdentity;
        self.SharedGroupName = nil;
        self.StoringType = A_SqliteStoringInLibraryFolder;
    }
    return self;
}
- (instancetype)initWithIdentity:(NSString *)databaseIdentity storingType:(A_SqliteStoringType)storingType
{
    self = [super init];
    if (self) {
        self.DatabaseIdentity = databaseIdentity;
        self.SharedGroupName = nil;
        self.StoringType = storingType;
    }
    return self;
}
- (instancetype)initWithIdentity:(NSString *)databaseIdentity group:(NSString *)group
{
    self = [super init];
    if (self) {
        self.DatabaseIdentity = databaseIdentity;
        self.SharedGroupName = group;
        self.StoringType = A_SqliteStoringInSharedGroup;
    }
    return self;
}


@end

@implementation A_SqliteQuery

+ (A_SqliteQuery *)createSqliteQuery:(NSString *)query andArgs:(NSArray *)args {
    A_SqliteQuery *s = [[A_SqliteQuery alloc] init];
    
    [s setSqlQuery:query];
    [s setArgs:args];
    
    return s;
}

@end

@interface A_SqliteManager()

@end

@implementation A_SqliteManager {
    sqlite3 *database;
    sqlite3_stmt *statement;
    NSFileManager *filemanager;
    NSMutableArray *ExistingTables;
    NSLock *sqlLock;
    
    A_DataModelDBIdentity *databaseIdentity;
}

#pragma mark - Database Operation


+ (A_SqliteManager *) A_Instance {
    return [A_SqliteManager A_InstanceWithIdentity:DEFAULT_SQLITE_NAME];
}
+ (A_SqliteManager *) A_InstanceWithIdentity: (NSString *)Identity {
    return [A_SqliteManager A_Instance:[[A_DataModelDBIdentity alloc] initWithIdentity:Identity]];
}
+ (A_SqliteManager *) A_Instance: (A_DataModelDBIdentity *)Identity {
    if (!Identity.DatabaseIdentity || [Identity.DatabaseIdentity length] == 0) {
        Identity.DatabaseIdentity = DEFAULT_SQLITE_NAME;
    }
    
    static dispatch_once_t pred = 0;
    __strong static NSMutableDictionary *_storage = nil;
    dispatch_once(&pred, ^{
        _storage = [[NSMutableDictionary alloc] init];
    });
    if (![_storage objectForKey:Identity.DatabaseIdentity] || [_storage objectForKey:Identity.DatabaseIdentity] == nil) {
        [_storage setObject:[[A_SqliteManager alloc] init:Identity] forKey:Identity.DatabaseIdentity];
    }
    
    return [_storage objectForKey:Identity.DatabaseIdentity];
}

- (instancetype) init: (A_DataModelDBIdentity *)DBIdentity {
    if ((self = [super init])) {
        sqlLock = [[NSLock alloc] init];
        databaseIdentity = DBIdentity;
        [self A_OpenConnetion];
    }
    return self;
}


- (BOOL) A_ReopenInSharedGroup:(NSString *)group {
    NSURL *groupFolder = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:group];
    if (!groupFolder) {
        return NO;
    }
    NSString *filePath = [[groupFolder URLByAppendingPathComponent:databaseIdentity.DatabaseIdentity] absoluteString];
    
    filemanager = [NSFileManager defaultManager];
    
    if ([self A_IsOpened]) {
        [self A_CloseConnetion];
        
        // Copy original sqlite to shared group
        if ([filemanager fileExistsAtPath:filePath]) {
            NSString  *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseIdentity.DatabaseIdentity];
            if ([filemanager fileExistsAtPath:defaultDBPath]) {
                [filemanager copyItemAtPath:defaultDBPath toPath:filePath error:NULL];
            }
        }
    }
    
    database = nil;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Initialize Database: could not open database (%s)", sqlite3_errmsg(database));
    }
    filemanager = nil;
    
    return YES;
}

- (BOOL) A_IsOpened {
    return database!=nil;
}
- (void) A_OpenConnetion {
    if (database) return;
    
    filemanager = [NSFileManager defaultManager];
    NSString  *dbpath = [self A_DBPath];
    if (![filemanager fileExistsAtPath:dbpath]) {
        NSString  *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseIdentity.DatabaseIdentity];
        if ([filemanager fileExistsAtPath:defaultDBPath]) {
            [filemanager copyItemAtPath:defaultDBPath toPath:dbpath error:NULL];
        } else {
            if (![filemanager createFileAtPath:dbpath contents:nil attributes:nil]) {
                NSLog(@"Create file sql file [%@] failed", dbpath);
                
                // Create document folder
                NSString *documentsDirectory = @"";
                switch (databaseIdentity.StoringType) {
                    case A_SqliteStoringInDocumentFolder:
                        documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
                        break;
                    case A_SqliteStoringInLibraryFolder:
                        documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        break;
                    case A_SqliteStoringInSharedGroup:
                        documentsDirectory = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:databaseIdentity.DatabaseIdentity] path];
                        break;
                    default:
                        break;
                }
                NSError *error = nil;
                [filemanager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
                if (error) {
                    NSLog(@"Create document folder [%@] failed", documentsDirectory);
                }
            }
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
    NSString *documentsDirectory = @"";
    
    switch (databaseIdentity.StoringType) {
        case A_SqliteStoringInDocumentFolder:
            documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
            break;
        case A_SqliteStoringInLibraryFolder:
            documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            break;
        case A_SqliteStoringInSharedGroup:
            documentsDirectory = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:databaseIdentity.SharedGroupName] path];
            break;
        default:
            break;
    }
    
    return [documentsDirectory stringByAppendingPathComponent:databaseIdentity.DatabaseIdentity];
}

#pragma mark - Execute SQL Queries

- (NSNumber *) A_ExecuteQuery:(NSString *) query {
    return [self A_ExecuteQuery:query withArgs:nil];
}
- (NSNumber *) A_ExecuteQuery:(NSString *) query withArgs:(NSArray*) args {
    [sqlLock lock];
    [self _bindSQL:[query UTF8String] withArray:args];
    if (statement == NULL) {
        [sqlLock unlock];
        return @0;
    }
    
    sqlite3_step(statement);
    NSNumber *result = nil;
    if(sqlite3_finalize(statement) == SQLITE_OK) {
        result = @(sqlite3_changes(database));
    } else {
        result = @0;
    }
    [sqlLock unlock];
    return result;
}

- (void) A_ExecuteQuery :(NSString *) query withBlock:(void (^)(id obj, NSNumber *result))finishBlock andArg:(id)obj{
    [A_TaskHelper A_RunInBackgroundWithParam:@[query,obj] Block:^id(id arg) {
        return [self A_ExecuteQuery:[arg objectAtIndex:0] withArgs:nil];
    } WhenDone:^(id arg, id result) {
        finishBlock([arg objectAtIndex:1], (NSNumber*)result);
    }];
}
- (void) A_ExecuteQuery :(NSString *) query withParams:(NSArray*) params block:(void (^)(id obj, NSNumber *result))finishBlock andArg:(id)obj{
    [A_TaskHelper A_RunInBackgroundWithParam:@[query,params,obj] Block:^id(id arg) {
        return [self A_ExecuteQuery:[arg objectAtIndex:0] withArgs:[arg objectAtIndex:1]];
    } WhenDone:^(id arg, id result) {
        finishBlock([arg objectAtIndex:2], (NSNumber*)result);
    }];
}

- (NSArray<NSDictionary<NSString *, id> *>*) A_SearchDataset:(NSString *) query {
    return [self A_SearchDataset:query withParams:nil];
}
- (NSArray<NSDictionary<NSString *, id> *>*) A_SearchDataset:(NSString *) query withParams:(NSArray*) params {
    [sqlLock lock];
    [self _bindSQL:[query UTF8String] withArray:params];
    if (statement == NULL) {
        [sqlLock unlock];
        return [[NSArray alloc] init];
    }
    
    NSMutableArray *dataset = [[NSMutableArray alloc] init];
    NSDictionary *row = nil;
    while ((row = [self _getRow])) {
        [dataset addObject:row];
    }
    [sqlLock unlock];
    return dataset;
}

- (void) A_SearchDataset:(NSString *) query withBlock:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj{
    [A_TaskHelper A_RunInBackgroundWithParam:@[query,obj] Block:^id(id arg) {
        return [self A_SearchDataset:[arg objectAtIndex:0] withParams:nil];
    } WhenDone:^(id arg, id result) {
        finishBlock([arg objectAtIndex:1], (NSArray*)result);
    }];
}
- (void) A_SearchDataset:(NSString *) query withParams:(NSArray*) params block:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj{
    [A_TaskHelper A_RunInBackgroundWithParam:@[query,params,obj] Block:^id(id arg) {
        return [self A_SearchDataset:[arg objectAtIndex:0] withParams:[arg objectAtIndex:1]];
    } WhenDone:^(id arg, id result) {
        finishBlock([arg objectAtIndex:2], (NSArray*)result);
    }];
}

- (NSDictionary<NSString *, id> *) _getRow {
    int rc = sqlite3_step(statement);
    if (rc == SQLITE_DONE) {
        sqlite3_finalize(statement);
        return nil;
    } else  if (rc == SQLITE_ROW) {
        int col_count = sqlite3_column_count(statement);
        if (col_count >= 1) {
            NSMutableDictionary  *dRow = [NSMutableDictionary dictionaryWithCapacity:col_count];
            for(int i = 0; i < col_count; i++) {
                dRow[ @(sqlite3_column_name(statement, i)) ] = [self _columnValue:i];
            }
            return dRow;
        }
    } else {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Can not get row %s \r\n -------- \r\n\r\n", sqlite3_errmsg(database));
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
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Can not get row %s \r\n -------- \r\n\r\n", sqlite3_errmsg(database));
#endif
        return nil;
    }
}

- (void) _bindSQL:(const char *) cQuery withArray:(NSArray *) params {
    NSInteger param_count;
    
    if (sqlite3_prepare_v2(database, cQuery, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Statement exception (%s) %s \r\n -------- \r\n\r\n", sqlite3_errmsg(database), cQuery);
        statement = NULL;
        return;
    }
    
    param_count = sqlite3_bind_parameter_count(statement);
    if (param_count != [params count]) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Parameters exception (%s) \r\n -------- \r\n\r\n", cQuery);
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
                    NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Unhandled ObjCType: %s query: %s \r\n -------- \r\n\r\n", [o objCType], cQuery);
                    statement = NULL;
                    return;
                }
            } else if ([o isKindOfClass:[NSString class]]) { // string
                sqlite3_bind_text(statement, i + 1, [o UTF8String], -1, SQLITE_TRANSIENT);
            } else {    // unhhandled type
                NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Unhandled parameter type: %@ query: %s \r\n -------- \r\n\r\n", [o class], cQuery);
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


+ (NSString*) A_CreateTableScript:(A_DataModel*) model {
    return [self A_CreateTableScript:model WithTableName:[A_SqliteManager A_GenerateTableName:model] AndKey:nil];
}
+ (NSString*) A_CreateTableScript:(A_DataModel*) model AndKey:(NSString*)key{
    return [self A_CreateTableScript:model WithTableName:[A_SqliteManager A_GenerateTableName:model] AndKey:key];
}
+ (NSString*) A_CreateTableScript:(A_DataModel*) model WithTableName:(NSString*)tableName AndKey:(NSString*)key{
    NSDictionary *properties = [A_Reflection A_PropertiesFromObject:model];
    
    NSString *_createTableSql = [NSString stringWithFormat:@"CREATE TABLE \"%@\" (", tableName];
    
    BOOL _first = YES;
    NSString *_format;
    NSString *_type;
    for (NSString *propertyName in properties) {
        if (_first) {
            _format = @"\"%@\" %@";
        } else {
            _format = @", \"%@\" %@";
        }
        
        _type = [A_SqliteManager _nameOfType:[properties objectForKey:propertyName]];
        
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

- (NSNumber*) A_CreateTable:(A_DataModel*) model {
    NSString *_sql = [A_SqliteManager A_CreateTableScript:model];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_CreateTable:(A_DataModel*) model AndKey:(NSString*)key {
    NSString *_sql = [A_SqliteManager A_CreateTableScript:model AndKey:key];
    return [self A_ExecuteQuery:_sql];
}
- (NSNumber*) A_CreateTable:(A_DataModel*) model WithTableName:(NSString*)tableName AndKey:(NSString*)key {
    NSString *_sql = [A_SqliteManager A_CreateTableScript:model WithTableName:tableName AndKey:key];
    return [self A_ExecuteQuery:_sql];
}

+ (A_SqliteQuery*) A_CreateInsertScript:(A_DataModel*) model {
    return [self A_CreateInsertScript:model WithIgnore:nil AndTable:[A_SqliteManager A_GenerateTableName:model]];
}
+ (A_SqliteQuery*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)keys {
    return [self A_CreateInsertScript:model WithIgnore:keys AndTable:[A_SqliteManager A_GenerateTableName:model]];
}
+ (A_SqliteQuery*) A_CreateInsertScript:(A_DataModel*) model WithTable:(NSString*)tableName {
    return [self A_CreateInsertScript:model WithIgnore:nil AndTable:tableName];
}
+ (A_SqliteQuery*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys AndTable:(NSString*)tableName {
    NSDictionary *properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray *_keys = [properties allKeys];
    
    BOOL _firstVal = YES;
    BOOL _ignore = NO;
    NSString *_valuesStr = [[NSString alloc] init];
    NSString *_keysStr = [[NSString alloc] init];
    NSMutableArray *_argsValue = [[NSMutableArray alloc] init];
    
    for (NSString *item in _keys) {
        _ignore = NO;
        for (NSString *_ignoreKey in ignoreKeys) {
            if ([[item lowercaseString] isEqualToString:[_ignoreKey lowercaseString]]) {
                _ignore = YES;
                break;
            }
        }
        if (_ignore) continue;
        
        if (_firstVal) {
            _keysStr = [_keysStr stringByAppendingFormat: @"`%@`", item];
            _valuesStr = [_valuesStr stringByAppendingString:@"?"];
        } else {
            _keysStr = [_keysStr stringByAppendingFormat: @",`%@`", item];
            _valuesStr = [_valuesStr stringByAppendingString:@",?"];
        }
        [_argsValue addObject:[model valueForKey:item]];
        
        _firstVal = NO;
    }
    
    NSString *_insterTableSql = [NSString stringWithFormat:@"INSERT INTO \"%@\" (%@) VALUES (%@)", tableName, _keysStr, _valuesStr];
    
    A_SqliteQuery *query = [A_SqliteQuery createSqliteQuery:_insterTableSql andArgs:_argsValue];
    return query;
}

- (BOOL) A_CompletedMissingFields:(A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys {
    NSString *_tableName = [A_SqliteManager A_GenerateTableName:model];
    
    // Get fields from database
    NSArray<NSDictionary *> *fieldsInDB = [self A_ExisitngFieldsWithModel:model];
    NSMutableArray<NSString *> *fieldsName = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in fieldsInDB) {
        if ([item objectForKey:@"name"]) {
            [fieldsName addObject:[item objectForKey:@"name"]];
        }
    }
    
    // Get fields from class
    NSDictionary *properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray<NSString *> *keysInModel = [properties allKeys];
    
    NSMutableArray<NSString *> *missingFields = [[NSMutableArray alloc] init];
    
    // Compare missing fields
    BOOL _ignore = NO, _keyExising = NO;
    for (NSString *item in keysInModel) {
        _ignore = NO;
        
        for (NSString *_ignoreKey in ignoreKeys) {
            if ([[item lowercaseString] isEqualToString:[_ignoreKey lowercaseString]]) {
                _ignore = YES;
                break;
            }
        }
        if (_ignore) {
            continue;
        }
        
        _keyExising = NO;
        for (NSString *_exisingKey in fieldsName) {
            if ([[item lowercaseString] isEqualToString:[_exisingKey lowercaseString]]) {
                _keyExising = YES;
                break;
            }
        }
        
        if (_keyExising) {
            [missingFields addObject:item];
        }
    }
    
    // If data any field is not existing then add them back
    if ([missingFields count] > 0) {
        NSString *_type;
        for (NSString *item in missingFields) {
            _type = [A_SqliteManager _nameOfType:[properties objectForKey:item]];
            NSString *_addColum = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", _tableName, item, _type];
            [self A_ExecuteQuery:_addColum];
        }
        
        return YES;
    } else {
        return NO;
    }
}

- (NSNumber*) A_Insert: (A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys AndTable:(NSString*)tableName{
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateInsertScript:model WithIgnore:ignoreKeys AndTable:tableName];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}
- (NSNumber*) A_Insert: (A_DataModel*) model WithTable:(NSString*)tableName{
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateInsertScript:model WithTable:tableName];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}
- (NSNumber*) A_Insert: (A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys{
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateInsertScript:model WithIgnore:ignoreKeys];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}
- (NSNumber*) A_Insert: (A_DataModel*) model{
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateInsertScript:model];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}

+ (A_SqliteQuery*) A_CreateUpdateScript:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    NSDictionary *properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray *_keys = [properties allKeys];
    
    NSString *_valuesStr = [[NSString alloc] init];
    NSString *_keysStr = [[NSString alloc] init];
    NSMutableArray *_argsValue = [[NSMutableArray alloc] init];
    NSMutableArray *_keysValue = [[NSMutableArray alloc] init];
    
    BOOL _isKey = NO;
    for (NSString *item in _keys) {
        _isKey = NO;
        if (keys.count > 0) {
            // If keys exist, put them to where
            for (NSString *_keys in keys) {
                if ([[item lowercaseString] isEqualToString:[_keys lowercaseString]]) {
                    if (_keysStr.length == 0) {
                        _keysStr = [_keysStr stringByAppendingFormat: @" `%@` = ?", item];
                    } else {
                        _keysStr = [_keysStr stringByAppendingFormat: @" AND `%@` = ?", item];
                    }
                    [_keysValue addObject:[model valueForKey:item]];
                    
                    _isKey = YES;
                    break;
                }
            }
        } else {
            // If keys not exist, put all to where
            if (_keysStr.length == 0) {
                _keysStr = [_keysStr stringByAppendingFormat: @" `%@` = ?", item];
            } else {
                _keysStr = [_keysStr stringByAppendingFormat: @" AND `%@` = ?", item];
            }
            [_keysValue addObject:[model valueForKey:item]];
        }
        
        if (!_isKey) {
            if (_valuesStr.length == 0) {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" `%@` = ?", item];
            } else {
                _valuesStr = [_valuesStr stringByAppendingFormat: @", `%@` = ?", item];
            }
            
            [_argsValue addObject:[model valueForKey:item]];
        }
    }
    
    NSString *_sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,_valuesStr, _keysStr];
    
    [_argsValue addObjectsFromArray:_keysValue];
    A_SqliteQuery *query = [A_SqliteQuery createSqliteQuery:_sql andArgs:_argsValue];
    return query;
}
+ (A_SqliteQuery*) A_CreateUpdateScript:(A_DataModel*) model AndKeys:(NSArray*)keys {
    return [self A_CreateUpdateScript:model WithTable:[A_SqliteManager A_GenerateTableName:model] AndKeys:keys];
}

- (NSNumber*) A_Update:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateUpdateScript:model WithTable:tableName AndKeys:keys];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}
- (NSNumber*) A_Update:(A_DataModel*) model AndKeys:(NSArray*)keys {
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateUpdateScript:model AndKeys:keys];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}

+ (A_SqliteQuery*) A_CreateDeleteScript:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    NSDictionary *properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray *_keys = [properties allKeys];
    
    NSString *_valuesStr = [[NSString alloc] init];
    NSMutableArray *_argsValue = [[NSMutableArray alloc] init];
    
    BOOL _isKey = NO;
    for (NSString *item in _keys) {
        if (keys) {
            _isKey = NO;
            for (NSString *_keys in keys) {
                if ([[item lowercaseString] isEqualToString:[_keys lowercaseString]]) {
                    _isKey = YES;
                }
            }
        } else {
            _isKey = YES;
        }
        
        if (_isKey) {
            if (_valuesStr.length == 0) {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" `%@` = ?", item];
            } else {
                _valuesStr = [_valuesStr stringByAppendingFormat: @" AND `%@` = ?", item];
            }
            [_argsValue addObject:[model valueForKey:item]];
        }
    }
    
    NSString *_sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,_valuesStr];
    
    A_SqliteQuery *query = [A_SqliteQuery createSqliteQuery:_sql andArgs:_argsValue];
    return query;
}
+ (A_SqliteQuery*) A_CreateDeleteScript:(A_DataModel*) model WithTable:(NSString*)tableName {
    return [self A_CreateDeleteScript:model WithTable:tableName AndKeys:nil];
}
+ (A_SqliteQuery*) A_CreateDeleteScript:(A_DataModel*) model AndKeys:(NSArray*)keys {
    return [self A_CreateDeleteScript:model WithTable:[A_SqliteManager A_GenerateTableName:model] AndKeys:keys];
}
+ (A_SqliteQuery*) A_CreateDeleteScript:(A_DataModel*) model {
    return [self A_CreateDeleteScript:model WithTable:[A_SqliteManager A_GenerateTableName:model] AndKeys:nil];
}

- (NSNumber*) A_Delete:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys {
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateDeleteScript:model WithTable:tableName AndKeys:keys];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}
- (NSNumber*) A_Delete:(A_DataModel*) model WithTable:(NSString*)tableName {
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateDeleteScript:model WithTable:tableName];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}
- (NSNumber*) A_Delete:(A_DataModel*) model AndKeys:(NSArray*)keys {
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateDeleteScript:model AndKeys:keys];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}
- (NSNumber*) A_Delete:(A_DataModel*) model {
    A_SqliteQuery *_sql = [A_SqliteManager A_CreateDeleteScript:model];
    return [self A_ExecuteQuery:_sql.SqlQuery withArgs:_sql.Args];
}

- (NSArray*) A_SearchSimilarModels:(A_DataModel*) model {
    return [self A_SearchSimilarModels:model WithTable:[A_SqliteManager A_GenerateTableName:model]];
}
- (NSArray*) A_SearchSimilarModels:(A_DataModel*) model WithTable:(NSString*)tableName {
    NSDictionary *properties = [A_Reflection A_PropertiesFromObject:model];
    NSArray *_keys = [properties allKeys];
    
    NSString *_valuesStr = [[NSString alloc] init];
    for (NSString *item in _keys) {
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
    
    NSString *_sql;
    if (_valuesStr.length == 0)
        _sql = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
    else
        _sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@",tableName,_valuesStr];
    
    NSArray *_result = [self A_SearchDataset:_sql];
    return [A_SqliteManager A_Mapping:_result ToClass:[A_Reflection A_GetClass:model]];
}

- (NSArray*) A_SearchModels:(Class)class Where:(NSString*)query WithTable:(NSString*)tableName {
//    NSString *_sql;
//    if (!query || query.length == 0)
//        _sql = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
//    else
//        _sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@",tableName,query];
//
//    NSArray *_result = [self A_SearchDataset:_sql];
//    return [A_SqliteManager A_Mapping:_result ToClass:class];
    
    return [self A_SearchModels:class Where:query WithTable:[A_SqliteManager A_GenerateTableNameWithModelClass:class]];
}
- (NSArray*) A_SearchModels:(Class)class Where:(NSString*)query{
    NSString *_className = NSStringFromClass(class);
    _className = [_className componentsSeparatedByString:@"."].lastObject;
    return [self A_SearchModels:class Where:query WithTable:[NSString stringWithFormat:@"A_%@_table",_className]];
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

+ (NSArray*) A_Mapping:(NSArray*)data ToClass:(Class)class{
    NSMutableArray *_array = [[NSMutableArray alloc] init];
    
    @try {
        NSDictionary<NSString *, NSString *> *properties = [A_Reflection A_PropertiesFromClass:class];
        
        for (NSDictionary *dic in data) {
            id obj = [[class alloc] init];
            for (NSString *key in dic) {
                NSString *propertyType = [properties objectForKey:key];
                if ([propertyType isEqualToString:@"NSDate"]) {
                    [obj setValue:[NSDate A_ConvertStringToDate:[dic objectForKey:key]] forKey:key];
                } else {
                    [obj setValue:[dic objectForKey:key] forKey:key];
                }
            }
            [_array addObject:obj];
        }
    }
    @catch (NSException *e) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Mapping ERROR (%@) \r\n -------- \r\n\r\n", e.reason);
    }
    
    return _array;
}
+ (NSString*) _nameOfType:(NSString*)type {
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
    
    NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <SQLite Manager> \r\n Unknow Type: %@ \r\n -------- \r\n\r\n", type);
    return @"REAL";
}

+ (Boolean) A_TableColumnMarch:(A_DataModel*) model {
    NSLog(@"TODO");
    return YES;
}

#pragma mark: - Gerneate table name from Model
+ (NSString*) A_GenerateTableNameWithModelClass: (Class)class {
    NSString *_className = NSStringFromClass(class);
    _className = [_className componentsSeparatedByString:@"."].lastObject;
    return [NSString stringWithFormat:@"A_%@_table",_className];
}
+ (NSString*) A_GenerateTableName: (A_DataModel*) model {
    NSString *_className = [A_Reflection A_GetClassNameFromObject:model];
    _className = [_className componentsSeparatedByString:@"."].lastObject;
    return [NSString stringWithFormat:@"A_%@_table",_className];
}

- (NSArray<NSDictionary *> *) A_ExisitngFieldsWithModelClass:(Class)class {
    return [self A_ExisitngFieldsWithTable:[A_SqliteManager A_GenerateTableNameWithModelClass:class]];
}
- (NSArray<NSDictionary *> *) A_ExisitngFieldsWithModel:(A_DataModel *) model {
    return [self A_ExisitngFieldsWithTable:[A_SqliteManager A_GenerateTableName:model]];
}
- (NSArray<NSDictionary *> *) A_ExisitngFieldsWithTable:(NSString *) tablename {
    NSString *_query = [NSString stringWithFormat:@"PRAGMA table_info(%@);", tablename];
    NSArray<NSDictionary *> *dataset = [self A_SearchDataset:_query];
    return dataset;
}


@end
