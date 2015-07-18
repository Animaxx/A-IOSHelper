//
//  A_Mapping.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Mapping Map
typedef id(^mapElementBlock)(id input);

@interface A_MappingMap : NSObject

@property (readonly, nonatomic) Class BindClass;
@property (readonly, nonatomic) Class ToClass;

+ (A_MappingMap*)A_InitBind:(Class)bindClass To:(Class)toClass;
- (A_MappingMap*)A_AddMemeber:(NSString*)key To:(NSString*)to;
- (A_MappingMap*)A_AddMemeber: (NSString*)key To:(NSString*)to Convert:(mapElementBlock)block;

@end

#pragma mark - Mapper
@interface A_Mapper : NSObject

+ (A_Mapper*) A_Instance;
- (A_MappingMap*) A_CreateMap:(Class)from To:(Class)to;
- (A_MappingMap*) A_CreateMapByName:(NSString*)from To:(NSString*)to;
- (A_MappingMap*) A_GetMap:(Class)from To:(Class)to;
- (A_MappingMap*) A_GetMapByName:(NSString*)from To:(NSString*)to;

- (void)A_Convert:(id)from To:(id)to;
- (id)A_Convert:(id)from ToClass:(Class)to;
- (id)A_Convert:(id)from ToClassName:(NSString*)to;

- (NSArray*)A_ConvertArray:(NSArray*)from ToClass:(Class)toClass;
- (NSArray*)A_ConvertArray:(NSArray*)from ToClassName:(NSString*)toClass;

@end
