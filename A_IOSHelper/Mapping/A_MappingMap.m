//
//  A_MappingMap.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_MappingMap.h"

#pragma mark - Item
@interface A_MappingItem : NSObject

@property (copy, nonatomic) mapElementBlock block;
@property (copy, nonatomic) NSString* outputField;

@end

@implementation A_MappingItem

+ (A_MappingItem*) A_Init:(mapElementBlock)block Output:(NSString*)OutputField {
    A_MappingItem* item = [[A_MappingItem alloc] init];
    [item setBlock:block];
    [item setOutputField:OutputField];
    return item;
}
- (void) _assignValue:(id)value toObj:(NSObject*)obj {
    @try {
        if (self.block) {
            [obj setValue:self.block(value) forKeyPath:self.outputField];
        } else {
            //TODO
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR");
    }
}

@end

#pragma mark - Map
@interface A_MappingMap ()

@property (readwrite, nonatomic) Class BindClass;
@property (readwrite, nonatomic) Class ToClass;
@property (strong, nonatomic) NSMutableDictionary* mappingDict;

@end

@implementation A_MappingMap

+ (A_MappingMap*) A_InitBind:(Class)bindClass To:(Class)toClass {
    A_MappingMap* map = [[A_MappingMap alloc] init];
    map.BindClass = bindClass;
    map.ToClass = toClass;
    return map;
}
-(instancetype)init {
    if ((self = [super init])) {
        self.mappingDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (A_MappingMap*)A_AddMemeber:(NSString*)key To:(NSString*)to Convert:(mapElementBlock)block {
    A_MappingItem* item = [A_MappingItem A_Init:block Output:to];
    [self.mappingDict setObject:item forKey:[key copy]];
    return self;
}
- (A_MappingMap*)A_AddMemeber:(NSString*)key To:(NSString*)to {
    return [self A_AddMemeber:key To:to Convert:nil];
}

- (void)A_MapData:(id)input To:(id)output {
    if (!input || !output) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Mapping object cannot be nil");
        return;
    }
    
    if (![input isMemberOfClass:self.BindClass] || ![output isMemberOfClass:self.ToClass]) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Class of object is not match");
        return;
    }
    
    A_MappingItem* item;
    for (NSString* key in self.mappingDict) {
        item = [self.mappingDict objectForKey:key];
        [item _assignValue:[input objectForKey:key] toObj:output];
    }
}
- (id)A_MapData:(id)input {
    if (!input) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Mapping object cannot be nil");
        return nil;
    }
    if (![input isMemberOfClass:self.BindClass]) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", @"Class of object is not match");
        return nil;
    }
    
    @try {
        id output = [self.ToClass init];
        
        A_MappingItem* item;
        for (NSString* key in self.mappingDict) {
            item = [self.mappingDict objectForKey:key];
            [item _assignValue:[input objectForKey:key] toObj:output];
        }
        
        return output;
    }
    @catch (NSException *exception) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Mapping data error>  \r\n %@ \r\n -------- \r\n\r\n", exception);
        return nil;
    }
}


@end








