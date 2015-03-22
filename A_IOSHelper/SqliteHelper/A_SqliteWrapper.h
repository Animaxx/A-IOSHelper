//
//  A_SqliteWrapper.h
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_SqliteWrapper : NSObject

+ (A_SqliteWrapper *) A_Init;
+ (A_SqliteWrapper *) A_Init: (NSString *)file;

- (id) init;
- (id) init: (NSString *)file;

- (void) A_OpenConnetion;
- (void) A_CloseConnetion;
- (void) dealloc;

- (NSString *) A_DBPath;

// SQL queries
- (NSNumber *) A_ExecuteQuery:(NSString *) query;
- (NSNumber *) A_ExecuteQuery:(NSString *) query withArgs:(NSArray*) args;

- (NSArray*) A_SearchForDataset:(NSString *) query;
- (NSArray*) A_SearchForDataset:(NSString *) query withParams:(NSArray*) params;

- (id) A_GetValueFromQuery:(NSString *) query;
- (id) A_GetValueFromQuery:(NSString *) query withParams:(NSArray*) params;

- (Boolean) A_TableExist:(NSString*) tableName;

// Utilities
- (NSNumber *) A_lastInsertId;

@end
