//
//  StoreDatafileHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_PlistHelper : NSObject

+ (void) A_Save:(id)dataObject byKey:(NSString*)key;
+ (id) A_GetByKey:(NSString*)key;
+ (void) A_CleanAll;

+ (void) A_Save:(id)dataObject toGroup:(NSString*)group andKey:(NSString*)key;
+ (id) A_GetByGroup:(NSString*)group andKey:(NSString*)key;
+ (void) A_CleanAllInGroup: (NSString*)group;

@end
