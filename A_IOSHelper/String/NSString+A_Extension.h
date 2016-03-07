//
//  NSString+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class A_MappingMap;

@interface NSString (A_Extension)

- (BOOL)A_CheckEmpty;
- (NSString *_Nonnull)A_StripHTMLTag;
- (NSString *_Nonnull)A_TrimString;
- (BOOL)A_ValidateEmail;
- (BOOL)A_MatchRegex:(NSString *_Nonnull)regex;
- (NSDate *_Nullable)A_ToDate:(NSString *_Nonnull)format;
- (NSDate *_Nullable)A_ToDateByDetailFormat;

- (NSDictionary *_Nonnull)A_CovertJSONToDictionary;
- (NSArray *_Nonnull)A_CovertJSONToArray;

- (_Nullable id)A_ConvertJSONToMappedClassWithName:(NSString *_Nonnull)className;
- (NSArray *_Nullable)A_ConvertJSONToMappedArrayWithClassName:(NSString *_Nonnull)className;

- (_Nullable id)A_ConvertJSONToMappedClass:(_Nonnull Class)classType;
- (NSArray *_Nullable)A_ConvertJSONToMappedArrayWithClass:(_Nonnull Class)classType;

- (_Nonnull id)A_ConvertJSONToMappedInstance:(_Nonnull id)obj;
- (_Nonnull id)A_ConvertJSONToObjectWithMap:(A_MappingMap *_Nonnull)map;
- (_Nonnull id)A_ConvertJSONToArrayWithMap:(A_MappingMap *_Nonnull)map;

@end
