//
//  A_Mapping.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// Mapper is for fast auto convert one class type to the other.

#pragma mark - Mapping Map
typedef id(^mapElementBlock)(id input);

@interface A_MappingMap : NSObject

@property (readonly, nonatomic) Class BindClass;
@property (readonly, nonatomic) Class ToClass;

+ (A_MappingMap*)A_InitBind:(Class)bindClass To:(Class)toClass;
- (A_MappingMap*)A_AddMemeber:(NSString*)key To:(NSString*)to;
- (A_MappingMap*)A_AddMemeber: (NSString*)key To:(NSString*)to Convert:(mapElementBlock)block;

- (void)A_ConvertData:(id)input To:(id)output;
- (NSObject *_Nullable)A_ConvertData:(NSObject *_Nullable)input;

@end

#pragma mark - Mapper
@interface A_Mapper : NSObject

+ (A_Mapper *_Nonnull) A_Instance;

- (A_MappingMap*) A_GetMap:(Class)from To:(Class)to;
- (A_MappingMap*) A_GetMapByName:(NSString*)from To:(NSString*)to;

- (void)A_RemoveMap:(Class)from To:(Class)to;
- (void)A_RemoveMapByName:(NSString*)from To:(NSString*)to;

- (void)A_Convert:(id)from To:(id)to;
- (id)A_Convert:(id)from ToClass:(Class)to;
- (id)A_Convert:(id)from ToClassName:(NSString*)to;

- (NSArray*)A_ConvertArray:(NSArray*)from ToClass:(Class)toClass;
- (NSArray*)A_ConvertArray:(NSArray*)from ToClassName:(NSString*)toClass;

@end
