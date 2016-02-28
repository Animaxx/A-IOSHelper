//
//  A_Mapping.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// Mapper is for fast auto convert one class type to the other.
typedef NS_ENUM(NSInteger, A_MappingExceptionType) {
    A_MappingExceptionType_Throw = 0,
    A_MappingExceptionType_Ignore
};

#pragma mark - Mapping Map
typedef _Nonnull id(^mapElementBlock)(_Nonnull id input);

@interface A_MappingMap : NSObject

@property (assign, atomic) A_MappingExceptionType ExceptionType;
@property (readonly, nonatomic) _Nonnull Class BindClass;
@property (readonly, nonatomic) _Nonnull Class ToClass;

+ (A_MappingMap *_Nonnull)A_InitBind:(_Nonnull Class)bindClass To:(_Nonnull Class)toClass;
- (A_MappingMap *_Nonnull)A_SetMemeber:(NSString *_Nonnull)key To:(NSString *_Nonnull)to;
- (A_MappingMap *_Nonnull)A_SetMemeber: (NSString *_Nonnull)key To:(NSString *_Nonnull)to Convert:(_Nullable mapElementBlock)block;

- (void)A_ConvertData:(_Nonnull id)input To:(_Nonnull id)output;
- (NSObject *_Nullable)A_ConvertData:(NSObject *_Nullable)input;

@end

#pragma mark - Mapper
@interface A_Mapper : NSObject

+ (A_Mapper *_Nonnull) A_Instance;

- (A_MappingMap *_Nonnull) A_GetMap:(_Nonnull Class)from To:(_Nonnull Class)to;
- (A_MappingMap *_Nonnull) A_GetMapByName:(NSString *_Nonnull)from To:(NSString *_Nonnull)to;

- (void)A_RemoveMap:(_Nonnull Class)from To:(_Nonnull Class)to;
- (void)A_RemoveMapByName:(NSString *_Nonnull)from To:(NSString *_Nonnull)to;

- (void)A_Convert:(_Nonnull id)from To:(_Nonnull id)to;
- (_Nonnull id)A_Convert:(_Nonnull id)from ToClass:(_Nonnull Class)to;
- (_Nonnull id)A_Convert:(_Nonnull id)from ToClassName:(NSString *_Nonnull)to;

- (NSArray *_Nonnull)A_ConvertArray:(NSArray *_Nonnull)from ToClass:(_Nonnull Class)toClass;
- (NSArray *_Nonnull)A_ConvertArray:(NSArray *_Nonnull)from ToClassName:(NSString *_Nonnull)toClass;

@end
