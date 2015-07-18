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

- (void) A_ExecuteQuery :(NSString *) query withBlock:(void (^)(id obj, NSNumber *result))finishBlock andArg:(id)obj;
- (void) A_ExecuteQuery :(NSString *) query withParams:(NSArray*) params block:(void (^)(id obj, NSNumber *result))finishBlock andArg:(id)obj;

- (NSArray*) A_SearchDataset:(NSString *) query;
- (NSArray*) A_SearchDataset:(NSString *) query withParams:(NSArray*) params;

- (void) A_SearchDataset:(NSString *) query withBlock:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj;
- (void) A_SearchDataset:(NSString *) query withParams:(NSArray*) params block:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj;

- (id) A_GetValueFromQuery:(NSString *) query;
- (id) A_GetValueFromQuery:(NSString *) query withParams:(NSArray*) params;

- (Boolean) A_TableExist:(NSString*) tableName;

#pragma mark - Data Model Methods
+ (NSString*) A_CreateTableScript:(A_DataModel*) model;
+ (NSString*) A_CreateTableScript:(A_DataModel*) model AndKey:(NSString*)key;
+ (NSString*) A_CreateTableScript:(A_DataModel*) model WithTableName:(NSString*)tableName AndKey:(NSString*)key;

- (NSNumber*) A_CreateTable:(A_DataModel*) model;
- (NSNumber*) A_CreateTable:(A_DataModel*) model AndKey:(NSString*)key;
- (NSNumber*) A_CreateTable:(A_DataModel*) model WithTableName:(NSString*)tableName AndKey:(NSString*)key;

+ (NSString*) A_CreateInsertScript:(A_DataModel*) model;
+ (NSString*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)keys;
+ (NSString*) A_CreateInsertScript:(A_DataModel*) model WithTable:(NSString*)tableName;
+ (NSString*) A_CreateInsertScript:(A_DataModel*) model WithIgnore:(NSArray*)keys AndTable:(NSString*)tableName;

- (NSNumber*) A_Insert: (A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys AndTable:(NSString*)tableName;
- (NSNumber*) A_Insert: (A_DataModel*) model WithTable:(NSString*)tableName;
- (NSNumber*) A_Insert: (A_DataModel*) model WithIgnore:(NSArray*)ignoreKeys;
- (NSNumber*) A_Insert: (A_DataModel*) model;

+ (NSString*) A_CreateUpdateScript:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys;
+ (NSString*) A_CreateUpdateScript:(A_DataModel*) model AndKeys:(NSArray*)keys;

- (NSNumber*) A_Update:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys;
- (NSNumber*) A_Update:(A_DataModel*) model AndKeys:(NSArray*)keys;

+ (NSString*) A_CreateDeleteScript:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys;
+ (NSString*) A_CreateDeleteScript:(A_DataModel*) model WithTable:(NSString*)tableName;
+ (NSString*) A_CreateDeleteScript:(A_DataModel*) model AndKeys:(NSArray*)keys;
+ (NSString*) A_CreateDeleteScript:(A_DataModel*) model;

- (NSNumber*) A_Delete:(A_DataModel*) model WithTable:(NSString*)tableName AndKeys:(NSArray*)keys;
- (NSNumber*) A_Delete:(A_DataModel*) model WithTable:(NSString*)tableName;
- (NSNumber*) A_Delete:(A_DataModel*) model AndKeys:(NSArray*)keys;
- (NSNumber*) A_Delete:(A_DataModel*) model;

- (NSArray*) A_SearchSimilarModels:(A_DataModel*) model;
- (NSArray*) A_SearchSimilarModels:(A_DataModel*) model WithTable:(NSString*)tableName;
- (NSArray*) A_SearchModels:(Class)class Where:(NSString*)query WithTable:(NSString*)tableName;
- (NSArray*) A_SearchModels:(Class)class Where:(NSString*)query;

#pragma mark - Utility Methods
- (NSNumber *) A_lastInsertId;
+ (NSArray*) A_Mapping:(NSArray*) data ToClass:(Class)class;
+ (Boolean) A_TableColumnMarch:(A_DataModel*) model;
+ (NSString*) A_GenerateTableName: (A_DataModel*) model;

@end
