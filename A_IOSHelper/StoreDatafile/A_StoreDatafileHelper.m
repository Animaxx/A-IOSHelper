//
//  StoreDatafileHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_StoreDatafileHelper.h"

@implementation A_StoreDatafileHelper

+ (void) A_SaveObjectToDatafile:(NSString*)key dataObject:(id)dataObject {
    if (!key || !dataObject) return;
    
    @autoreleasepool {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (id) A_GetObjectFromDatafile:(NSString*)_key {
    @autoreleasepool {
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        if (![ud objectForKey:_key])
        {
            return nil;
        } else {
            NSData* data = [ud objectForKey:_key];
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
}
+ (void) A_CleanObjectFromDatafile {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [NSUserDefaults resetStandardUserDefaults];
}
+ (void) A_CleanFilesFromDocuments {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:@"Documents/" error:nil];
    for (NSString *filename in fileArray)  {
        [fileMgr removeItemAtPath:[@"Documents/" stringByAppendingPathComponent:filename] error:nil];
    }
}
+ (void) A_RemoveFileFromDocuments: (NSString*)filename {
    [[NSFileManager defaultManager] removeItemAtPath:
        [NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat:@"Documents/%@",filename]]
                                               error:nil];
}

+ (NSString *)A_GetDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

@end



