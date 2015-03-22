//
//  A_SQLManager.h
//  A_IOSHelper
//
//  Created by Animax on 3/21/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A_DataModel.h"
#import "A_SqliteWrapper.h"

@interface A_SQLManager : NSObject

@property (strong, nonatomic) A_SqliteWrapper* SqlWrapper;

- (A_SQLManager*) init;
- (A_SQLManager*) init:(NSString*)name;

- (BOOL) A_Add:(A_DataModel*)model;
- (BOOL) A_Delete:(A_DataModel*)model;

/**
 For searching, you just need to put the "where" part string in it. Such as "id<10 and type=1"
**/
- (NSArray*) A_Search:(Class)modelClass Query:(NSString*)partQuery;

@end
