//
//  A_DataModel.h
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_DataModel : NSObject<NSCoding>


- (nonnull NSDictionary*)A_Serialize;
+ (nonnull NSObject*)A_Deserialize: (nonnull NSDictionary*)Array;

- (nullable NSString*)A_ConvertToJSON;
+ (nonnull NSObject*)A_ConvertFromJSON: (nonnull NSString*)JSON;

- (void)A_SaveToPlist;
- (void)A_DeleteInPlist;
+ (nonnull NSArray*)A_GetFromPliste;
+ (void)A_ClearFromPlist;

- (nonnull NSNumber *)A_SaveToSqliteWithKey: (nonnull NSString *)tableKey;
- (void)A_InsertToSqlite;
- (void)A_DeleteModelInSqlite;
- (void)A_DeleteModelInSqliteWithKeys: (nonnull NSArray<NSString *> *)tableKeys;
- (nonnull NSArray*)A_SearchSimilarModelsInSqlite;
+ (nonnull NSArray*)A_SearchSqlite: (nullable NSString*)where;

- (void)A_SearchSimilarModelsInSqliteWithBlock:(nonnull void (^)(id _Nullable obj, NSArray *_Nullable result))finishBlock andArg:(nullable id)obj;
+ (void)A_SearchSqlite: (nullable NSString*)where withBlock:(nonnull void (^)(id _Nullable obj, NSArray *_Nullable result))finishBlock andArg:(nullable id)obj;

#pragma mark - Override
- (nonnull NSString *)nameOfDatabaseFile;

#pragma mark - NSCoding
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder;
- (nonnull id)initWithCoder:(nonnull NSCoder *)aDecoder;
#pragma mark -

@end
