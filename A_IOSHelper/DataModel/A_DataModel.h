//
//  A_DataModel.h
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_DataModel : NSObject<NSCoding>


- (NSDictionary*)A_Serialize;
+ (NSObject*)A_Deserialize: (NSDictionary*)Array;

- (NSString*)A_ConvertToJSON;
+ (NSObject*)A_ConvertFromJSON: (NSString*)JSON;

- (void)A_SaveToPlist;
- (void)A_DeleteInPlist;
+ (NSArray*)A_GetFromPliste;
+ (void)A_ClearFromPlist;

- (NSNumber *)A_SaveToSqliteWithKey: (NSString *)tableKey;
- (void)A_InsertToSqlite;
- (void)A_DeleteModelInSqlite;
- (NSArray*)A_SearchSimilarModelsInSqlite;
+ (NSArray*)A_SearchSqlite: (NSString*)where;

- (void)A_SearchSimilarModelsInSqliteWithBlock:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj;
+ (void)A_SearchSqlite: (NSString*)where withBlock:(void (^)(id obj, NSArray *result))finishBlock andArg:(id)obj;

#pragma mark - OVerride
- (NSString *)nameOfDatabaseFile;

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
#pragma mark -

@end
