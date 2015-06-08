//
//  A_Mapping.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_Mapper.h"
#import "A_Reflection.h"
#import "A_MappingMap.h"
#import "NSDictionary+A_Extension.h"

@interface A_Mapper ()

@property (strong, nonatomic) NSMutableDictionary* MapDict;

@end

@implementation A_Mapper

+ (A_Mapper*) A_Init {
    return [[A_Mapper alloc] init];
}
- (instancetype) init {
    if ((self = [super init])) {
        self.MapDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (A_MappingMap*) A_CreateMap:(Class)from To:(Class)to {
    A_MappingMap* map = [A_MappingMap A_InitBind:from To:to];
    
    [self.MapDict setObject:map forKey: [NSString stringWithFormat:@"%@_%@",
         [A_Reflection A_GetClassName:from], [A_Reflection A_GetClassName:to]]];
    
    return map;
}
- (A_MappingMap*) A_CreateMapByName:(NSString*)from To:(NSString*)to {
    Class fromClass = [A_Reflection A_GetClassByName:from];
    Class toClass = [A_Reflection A_GetClassByName:to];
    // TODO Try catch
    
    A_MappingMap* map = [A_MappingMap A_InitBind:fromClass To:toClass];
    [self.MapDict setObject:map forKey: [NSString stringWithFormat:@"%@_%@",from, to]];
    
    return map;
}
- (A_MappingMap*) A_GetMap:(Class)from To:(Class)to {
    NSString* key = [NSString stringWithFormat:@"%@_%@",
                     [A_Reflection A_GetClassName:from], [A_Reflection A_GetClassName:to]];
    return [self.MapDict objectForKey:key];
}
- (A_MappingMap*) A_GetMapByName:(NSString*)from To:(NSString*)to {
    NSString* key = [NSString stringWithFormat:@"%@_%@",from,to];
    return [self.MapDict objectForKey:key];
}

- (void)A_Map:(id)from To:(id)to {
    if (!from || !to) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Param cannot be nil");
        return;
    }
    
    NSString* _key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassNameFromObject:to]];
    
    A_MappingMap* map = [self.MapDict objectForKey:_key];
    if (!map) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n Cannot found the map between %@ and %@\r\n -------- \r\n\r\n", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassNameFromObject:to]);
        return;
    }
    
    [map A_MapData:from To:to];
}
- (id)A_Map:(id)from ToClass:(Class)to {
    if (!from || !to) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Params cannot be nil");
        return nil;
    }
    
    NSString* _key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassName:to]];
    
    A_MappingMap* map = [self.MapDict objectForKey:_key];
    if (!map) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n Cannot found the map between %@ and %@\r\n -------- \r\n\r\n", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassName:to]);
        return nil;
    }
    
    id output = [map A_MapData:from];
    return output;
}
- (id)A_Map:(id)from ToClassName:(NSString*)to {
    if (!from || !to) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Params cannot be nil");
        return nil;
    }
    
    NSString* _key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassNameFromObject:from], to];
    
    A_MappingMap* map = [self.MapDict objectForKey:_key];
    if (!map) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n Cannot found the map between %@ and %@\r\n -------- \r\n\r\n", [A_Reflection A_GetClassNameFromObject:from], to);
        return nil;
    }
    
    id output = [map A_MapData:from];
    return output;
}


@end


