//
//  CollectionHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_CollectionHelper : NSObject

+ (NSArray*)A_DictionaryToArray:(NSDictionary*)dict;
+ (NSDictionary*)A_CombineArraysToDictionary: (NSArray*)Keys Values:(NSArray*)values;

+ (NSArray *) A_SortedKeys:(NSDictionary*) dic;
+ (void)A_SwapArray: (NSMutableArray*)array1 With:(NSMutableArray*)array2;
+ (void)A_SwapDictionary:(NSMutableDictionary *)dictionary1 With:(NSMutableDictionary *)dictionary2;

@end
