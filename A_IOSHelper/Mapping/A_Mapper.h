//
//  A_Mapping.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A_MappingMap.h"

@interface A_Mapper : NSObject

+ (A_Mapper*) A_Init;
- (A_MappingMap*) A_CreateMap:(Class)from To:(Class)to;
- (A_MappingMap*) A_CreateMapByName:(NSString*)from To:(NSString*)to;
- (A_MappingMap*) A_GetMap:(Class)from To:(Class)to;
- (A_MappingMap*) A_GetMapByName:(NSString*)from To:(NSString*)to;

- (void)A_Map:(id)from To:(id)to;
- (id)A_Map:(id)from ToClass:(Class)to;
- (id)A_Map:(id)from ToClassName:(NSString*)to;

@end
