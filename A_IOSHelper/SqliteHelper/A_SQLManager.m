//
//  A_SQLManager.m
//  A_IOSHelper
//
//  Created by Animax on 3/21/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_SQLManager.h"
#import "A_Reflection.h"

@interface A_SQLManager()

@end

@implementation A_SQLManager

+ (A_SQLManager*) A_Init {
    return [[A_SQLManager alloc] init];
}
+ (A_SQLManager*) A_Init: (NSString*)name {
    return [[A_SQLManager alloc] init:name];
}

- (A_SQLManager*) init {
    if ((self = [super init])) {
        self.SqlWrapper = [A_SqliteWrapper init];
    }
    return self;
}
- (A_SQLManager*) init:(NSString*)name {
    if ((self = [super init])) {
        self.SqlWrapper = [A_SqliteWrapper A_Init:name];
    }
    return self;
}

- (BOOL) _createTable:(NSString*)tableName Properties:(NSDictionary*)properties {
    
    return YES;
}

- (BOOL) A_Add:(A_DataModel*)model {
     NSString* _className = [A_Reflection A_GetClassNameFromObject:model];
    
    
    return YES;
}
- (BOOL) A_Delete:(A_DataModel*)model{
    
    return YES;
}

- (NSArray*) A_Search:(Class)modelClass Query:(NSString*)partQuery{
    
    return [[NSArray alloc] init];
}

@end
