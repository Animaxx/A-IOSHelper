//
//  A_Mapping.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_Mapper.h"
#import "A_Reflection.h"
#import "NSDictionary+A_Extension.h"

#pragma mark - Mapping Map Item

@interface A_MappingItem : NSObject

@property (copy, nonatomic) mapElementBlock block;
@property (copy, nonatomic) NSString *outputField;

@end

@implementation A_MappingItem

+ (A_MappingItem*) A_Init:(mapElementBlock)block Output:(NSString*)OutputField {
    A_MappingItem *item = [[A_MappingItem alloc] init];
    [item setBlock:block];
    [item setOutputField:OutputField];
    return item;
}
- (void) _assignSourceInst:(id)source key:(NSString *)key toOutcomeInst:(NSObject*)outcome {
    @try {
        id inputValue = [source valueForKeyPath:key];
        if (self.block) {
            [outcome setValue:self.block(inputValue) forKeyPath:self.outputField];
        } else {
            // TODO: convert different property type
            [outcome setValue:inputValue forKeyPath:self.outputField];
        }
    }@catch (NSException *exception) {
        [NSException raise:@"Convert item exception" format:@"Error from converting %@ to %@", key, _outputField];
    }
}

@end

#pragma mark -
#pragma mark - Mapping Map
@interface A_MappingMap ()

@property (readwrite, nonatomic) Class BindClass;
@property (readwrite, nonatomic) Class ToClass;
@property (strong, nonatomic) NSMutableDictionary *mappingDict;

@end

@implementation A_MappingMap

+ (A_MappingMap*) A_InitBind:(Class)bindClass To:(Class)toClass {
    A_MappingMap *map = [[A_MappingMap alloc] init];
    map.BindClass = bindClass;
    map.ToClass = toClass;
    return map;
}
- (instancetype)init {
    if ((self = [super init])) {
        self.mappingDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (A_MappingMap*)A_SetMemeber:(NSString*)key To:(NSString*)to Convert:(mapElementBlock)block {
    A_MappingItem *item = [A_MappingItem A_Init:block Output:to];
    [self.mappingDict setObject:item forKey:[key copy]];
    return self;
}
- (A_MappingMap*)A_SetMemeber:(NSString*)key To:(NSString*)to {
    return [self A_SetMemeber:key To:to Convert:nil];
}

- (void)A_ConvertData:(id)input To:(id)output {
    if (!input || !output) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Mapping object cannot be nil");
        return;
    }
    
    if (![input isMemberOfClass:self.BindClass] || ![output isMemberOfClass:self.ToClass]) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Class of object is not match");
        return;
    }
    
    A_MappingItem *item;
    for (NSString *key in self.mappingDict) {
        item = [self.mappingDict objectForKey:key];
        [item _assignSourceInst:input key:key toOutcomeInst:output];
    }
}
- (id)A_ConvertData:(id)input {
    if (!input) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Mapping object cannot be nil");
        return nil;
    }
    if (![input isMemberOfClass:self.BindClass]) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Class of object is not match");
        return nil;
    }
    
    @try {
        id output = [[self.ToClass alloc] init];
        
        A_MappingItem *item;
        for (NSString *key in self.mappingDict) {
            item = [self.mappingDict objectForKey:key];
            [item _assignSourceInst:input key:key toOutcomeInst:output];
        }
        
        return output;
    }
    @catch (NSException *exception) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", exception);
        return nil;
    }
}

@end

#pragma mark -
#pragma mark - Mapper
@interface A_Mapper ()

@property (strong, nonatomic) NSMutableDictionary *MapDict;

@end

@implementation A_Mapper

+ (A_Mapper*) A_Instance {
    static A_Mapper *mapper = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        mapper = [[self alloc] init];
    });
    return mapper;
}
- (instancetype) init {
    if ((self = [super init])) {
        self.MapDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (A_MappingMap*) A_GetMap:(Class)from To:(Class)to {
    NSString *key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassName:from], [A_Reflection A_GetClassName:to]];
    A_MappingMap *map = [self.MapDict objectForKey:key];
    if (!map) {
        map = [A_MappingMap A_InitBind:from To:to];
        [self.MapDict setObject:map forKey:key];
    }
    return map;
}
- (A_MappingMap*) A_GetMapByName:(NSString*)from To:(NSString*)to {
    NSString *key = [NSString stringWithFormat:@"%@_%@",from,to];
    A_MappingMap *map = [self.MapDict objectForKey:key];
    if (!map) {
        map = [A_MappingMap A_InitBind:[A_Reflection A_GetClassByName:from] To:[A_Reflection A_GetClassByName:to]];
        [self.MapDict setObject:map forKey:key];
    }
    return map;
}

- (void)A_RemoveMap:(Class)from To:(Class)to {
    NSString *key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassName:from], [A_Reflection A_GetClassName:to]];
    [self.MapDict removeObjectForKey:key];
}
- (void)A_RemoveMapByName:(NSString*)from To:(NSString*)to {
    NSString *key = [NSString stringWithFormat:@"%@_%@",from,to];
    [self.MapDict removeObjectForKey:key];
}

- (void)A_Convert:(id)from To:(id)to {
    if (!from || !to) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Param cannot be nil");
        return;
    }
    
    NSString *_key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassNameFromObject:to]];
    
    A_MappingMap *map = [self.MapDict objectForKey:_key];
    if (!map) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n Cannot found the map between %@ and %@\r\n -------- \r\n\r\n", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassNameFromObject:to]);
        return;
    }
    
    [map A_ConvertData:from];
}
- (id)A_Convert:(id)from ToClass:(Class)to {
    if (!from || !to) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Params cannot be nil");
        return nil;
    }
    
    NSString *_key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassName:to]];
    
    A_MappingMap *map = [self.MapDict objectForKey:_key];
    if (!map) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n Cannot found the map between %@ and %@\r\n -------- \r\n\r\n", [A_Reflection A_GetClassNameFromObject:from], [A_Reflection A_GetClassName:to]);
        return nil;
    }
    
    id output = [map A_ConvertData:from];
    return output;
}
- (id)A_Convert:(id)from ToClassName:(NSString*)to {
    if (!from || !to) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Params cannot be nil");
        return nil;
    }
    
    NSString *_key = [NSString stringWithFormat:@"%@_%@", [A_Reflection A_GetClassNameFromObject:from], to];
    
    A_MappingMap *map = [self.MapDict objectForKey:_key];
    if (!map) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n Cannot found the map between %@ and %@\r\n -------- \r\n\r\n", [A_Reflection A_GetClassNameFromObject:from], to);
        return nil;
    }
    
    id output = [map A_ConvertData:from];
    return output;
}

- (NSArray*)A_ConvertArray:(NSArray*)from ToClass:(Class)toClass {
    NSMutableArray *_list = [[NSMutableArray alloc] init];
    
    for (id item in from) {
        id coverted = [self A_Convert:item ToClass:toClass];
        if (coverted) {
            [_list addObject:coverted];
        }
    }
    
    return _list;
}
- (NSArray*)A_ConvertArray:(NSArray*)from ToClassName:(NSString*)toClass {
    NSMutableArray *_list = [[NSMutableArray alloc] init];
    
    for (id item in from) {
        id coverted = [self A_Convert:item ToClassName:toClass];
        if (coverted) {
            [_list addObject:coverted];
        }
    }
    
    return _list;
}

#pragma mark -


@end


