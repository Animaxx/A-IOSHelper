//
//  A_SqliteWrapper.h
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_SqliteWrapper : NSObject

- (A_SqliteWrapper *) initWithDBFilename: (NSString *)file;
- (void) openDB;
- (void) closeDB;
- (void) dealloc;

- (NSString *) A_DBPath;

// SQL queries
- (NSNumber *) A_ExecuteQuery:(NSString *) query;
- (NSNumber *) A_ExecuteQuery:(NSString *) query withArgs:(NSArray*) args;

- (NSArray*) A_SearchForDataset:(NSString *) query;
- (NSArray*) A_SearchForDataset:(NSString *) query withParams:(NSArray*) params;

- (id) A_GetValueFromQuery:(NSString *) query;
- (id) A_GetValueFromQuery:(NSString *) query withParams:(NSArray*) params;

- (void) bindSQL:(const char *) cQuery withArray:(NSArray *) params;
- (Boolean) A_TableExist:(NSString*) tableName;

// Utilities
- (id) columnValue:(int) columnIndex;
- (NSNumber *) lastInsertId;

@end
