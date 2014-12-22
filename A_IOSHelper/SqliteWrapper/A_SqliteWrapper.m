//
//  A_SqliteWrapper.m
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import "A_SqliteWrapper.h"
#import <sqlite3.h>

@implementation A_SqliteWrapper

sqlite3 *database;
sqlite3_stmt *statement;
NSString *databaseFileName;
NSFileManager *filemanager;

#pragma mark - Database Operation

- (A_SqliteWrapper *) initWithDBFilename: (NSString *)file {
    if ((self = [super init])) {
        databaseFileName = file;
        [self openDB];
    }
    return self;
}

- (void) openDB {
    if (database) return;
    filemanager = [[NSFileManager alloc] init];
    NSString * dbpath = [self A_DBPath];
    
    if (![filemanager fileExistsAtPath:dbpath]) {
        // try to copy from default, if we have it
        NSString * defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseFileName];
        if ([filemanager fileExistsAtPath:defaultDBPath]) {
            // NSLog(@"copy default DB");
            [filemanager copyItemAtPath:defaultDBPath toPath:dbpath error:NULL];
        }
    }
    if (sqlite3_open([dbpath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error: initializeDatabase: could not open database (%s)", sqlite3_errmsg(database));
    }
    filemanager = nil;
}
- (void) closeDB {
    if (database) sqlite3_close(database);
    database = NULL;
    filemanager = nil;
}
- (void) dealloc {
    [self closeDB];
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
    const char *cQuery = [query UTF8String];
    [self bindSQL:cQuery withArray:args];
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
//    const char *cQuery = [query UTF8String];
    [self bindSQL:[query UTF8String] withArray:params];
    if (statement == NULL) return [[NSArray alloc] init];
    
    NSMutableArray* dataset = [[NSMutableArray alloc] init];
    NSDictionary * row = nil;
    while ((row = [self _GetRow])) {
        [dataset addObject:row];
    }
    
    return dataset;
}

- (NSDictionary*) _GetRow {
    int rc = sqlite3_step(statement);
    if (rc == SQLITE_DONE) {
        sqlite3_finalize(statement);
        return nil;
    } else  if (rc == SQLITE_ROW) {
        int col_count = sqlite3_column_count(statement);
        if (col_count >= 1) {
            NSMutableDictionary * dRow = [NSMutableDictionary dictionaryWithCapacity:col_count];
            for(int i = 0; i < col_count; i++) {
                dRow[ @(sqlite3_column_name(statement, i)) ] = [self columnValue:i];
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
    [self bindSQL:[query UTF8String] withArray:params];
    if (statement == NULL) return nil;
    
    int rc = sqlite3_step(statement);
    if (rc == SQLITE_DONE) {
        sqlite3_finalize(statement);
        return nil;
    } else  if (rc == SQLITE_ROW) {
        int col_count = sqlite3_column_count(statement);
        if (col_count < 1) return nil;
        id o = [self columnValue:0];
        sqlite3_finalize(statement);
        return o;
    } else {
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <SQlite error>  \r\n Can not get row %s", sqlite3_errmsg(database));
#endif
        return nil;
    }
}

- (void) bindSQL:(const char *) cQuery withArray:(NSArray *) params {
    NSInteger param_count;
    
    if (sqlite3_prepare_v2(database, cQuery, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"could not prepare statement (%s) %s", sqlite3_errmsg(database), cQuery);
        statement = NULL;
        return;
    }
    
    param_count = sqlite3_bind_parameter_count(statement);
    if (param_count != [params count]) {
        NSLog(@"wrong number of parameters (%s)", cQuery);
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
                    NSLog(@"Unhandled objCType: %s query: %s", [o objCType], cQuery);
                    statement = NULL;
                    return;
                }
            } else if ([o isKindOfClass:[NSString class]]) { // string
                sqlite3_bind_text(statement, i + 1, [o UTF8String], -1, SQLITE_TRANSIENT);
            } else {    // unhhandled type
                NSLog(@"Unhandled parameter type: %@ query: %s", [o class], cQuery);
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

//#pragma mark - CRUD Methods
//
//- (NSNumber *) insertRow:(NSDictionary *) record {
//    // NSLog(@"%s", __FUNCTION__);
//    NSInteger dictSize = [record count];
//    NSArray * vArray = [record allValues];
//    
//    // construct the query
//    NSMutableArray * placeHoldersArray = [NSMutableArray arrayWithCapacity:dictSize];
//    for (NSInteger i = 0; i < dictSize; ++i)  // array of ? markers for placeholders in query
//        [placeHoldersArray addObject: @"?"];
//    
//    NSString * query = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",
//                        tableName,
//                        [[record allKeys] componentsJoinedByString:@","],
//                        [placeHoldersArray componentsJoinedByString:@","]];
//    
//    [self bindSQL:[query UTF8String] withArray:vArray];
//    sqlite3_step(statement);
//    if(sqlite3_finalize(statement) == SQLITE_OK) {
//        return [self lastInsertId];
//    } else {
//        NSLog(@" sqlite3_finalize failed (%s)", sqlite3_errmsg(database));
//        return @0;
//    }
//}
//
//- (void) updateRow:(NSDictionary *) record forRowID:(NSNumber *)rowID {
//    // NSLog(@"%s", __FUNCTION__);
//    NSInteger dictSize = (int) [record count];
//    
//    NSMutableArray * vArray = [NSMutableArray arrayWithCapacity:dictSize + 1];
//    [vArray addObjectsFromArray:[record allValues]];
//    [vArray addObject:rowID];
//    
//    NSString * query = [NSString stringWithFormat:@"update %@ set %@ = ? where id = ?",
//                        tableName,
//                        [[record allKeys] componentsJoinedByString:@" = ?, "]];
//    
//    [self bindSQL:[query UTF8String] withArray:vArray];
//    sqlite3_step(statement);
//    if(sqlite3_finalize(statement) != SQLITE_OK) {
//        NSLog(@"sqlite3_finalize failed (%s)", sqlite3_errmsg(database));
//    }
//}
//
//- (void) deleteRow:(NSNumber *) rowID {
//    // NSLog(@"%s", __FUNCTION__);
//    
//    NSString * query = [NSString stringWithFormat:@"delete from %@ where id = ?", tableName];
//    [self executeQuery:query withArgs:@[rowID]];
//}
//
//- (NSDictionary *) getRow: (NSNumber *) rowID {
//    NSString * query = [NSString stringWithFormat:@"select * from %@ where id = ?", tableName];
//    [self prepareQuery:query withArgs:@[rowID]];
//    return [self getPreparedRow];
//}
//
//- (NSNumber *) countRows {
////    return [self valueFromQuery:[NSString stringWithFormat:@"select count(*) from %@", tableName]];
//    return [self valueFromQuery:[NSString stringWithFormat:@"select count(*) from %@", tableName] withArgs:nil];
//}
//

//#pragma mark - Keyed Subscripting methods
//- (NSDictionary *) objectForKeyedSubscript: (NSNumber *) rowID {
//    return [self getRow:rowID];
//}
//- (void) setObject:(NSDictionary *) record forKeyedSubscript: (NSNumber *) rowID {
//    [self updateRow:record forRowID:rowID];
//}

#pragma mark - Utility Methods

- (id) columnValue:(int) columnIndex {
    // NSLog(@"%s columnIndex: %d", __FUNCTION__, columnIndex);
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

- (NSNumber *) lastInsertId {
    return [NSNumber numberWithLongLong:sqlite3_last_insert_rowid(database)];
}


@end
