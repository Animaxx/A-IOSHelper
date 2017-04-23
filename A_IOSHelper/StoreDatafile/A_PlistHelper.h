//
//  StoreDatafileHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_PlistHelper : NSObject

+ (void) A_Save:(nonnull id)dataObject byKey:(nonnull NSString*)key;
+ (nullable id) A_GetByKey:(nonnull NSString*)key;
+ (void) A_CleanAll;

+ (void) A_Save:(nonnull id)dataObject toGroup:(nonnull NSString*)group andKey:(nonnull NSString*)key;
+ (nullable id) A_GetByGroup:(nonnull NSString*)group andKey:(nonnull NSString*)key;
+ (void) A_CleanAllInGroup: (nonnull NSString*)group;

@end
