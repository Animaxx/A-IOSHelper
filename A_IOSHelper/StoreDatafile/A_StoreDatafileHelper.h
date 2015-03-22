//
//  StoreDatafileHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_StoreDatafileHelper : NSObject

+ (void) A_SaveObjectToDatafile:(NSString*)key dataObject:(id)dataObject;
+ (id) A_GetObjectFromDatafile:(NSString*)_key;
+ (void) A_CleanObjectFromDatafile;
+ (void) A_CleanFilesFromDocuments;
+ (void) A_RemoveFileFromDocuments: (NSString*)filename;



@end
