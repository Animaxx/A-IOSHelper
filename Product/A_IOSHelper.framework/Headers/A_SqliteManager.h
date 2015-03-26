//
//  A_SqliteWrapper.h
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A_DataModel.h"

@interface A_SqliteManager : NSObject

+ (A_SqliteManager *) A_Instance;
+ (A_SqliteManager *) A_Instance: (NSString *)file;

- (id) init;
- (id) init: (NSString *)file;

- (BOOL) A_IsOpened;
- (void) A_OpenConnetion;
- (void) A_CloseConnetion;
- (void) dealloc;

- (NSString *) A_DBPath;

#pragma mark - SQL Queries
- (NSNumber *) A_ExecuteQuery:(NSString *) query;
- (NSNumber *) A_ExecuteQuery:(NSString *) query withArgs:(NSArray*) args;

- (NSArray*) A_SearchForDataset:(NSString *) query;
- (NSArray*) A_SearchForDataset:(NSString *) query withParams:(NSArray*) params;

- (id) A_GetValueFromQuery:(NSString *) query;
- (id) A_GetValueFromQuery:(NSString *) query withParams:(NSArray*) params;

- (Boolean) A_TableExist:(NSString*) tableName;

#pragma mark - Data Model Methods
- (Boolean) A_TableColumnMarch:(A_DataModel*) model;
- (NSString*) A_GenerateTableName: (A_DataModel*) model;

- (NSString*) A_CreateTableScript:(A_DataModel*) model AndKey:(NSString*)key;
- (NSString*) A_CreateTableScript:(A_DataModel*) model WithTableName:(NSString*)tableName AndKey:(NSString*)key;

- (NSString*) A_CreateInsertScript:(A_DataModel*) model;
- (NSString*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)keys;
- (NSString*) A_CreateInsertScript:(A_DataModel*) model WithTable:(NSString*)tableName;
- (NSString*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)keys AndTable:(NSString*)tableName;


#pragma mark - Utility Methods
- (NSNumber *) A_lastInsertId;

@end
