//
//  StoreDatafileHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_PlistHelper.h"

@implementation A_PlistHelper

+ (void) A_Save:(id)dataObject byKey:(NSString*)key {
    if (!key || !dataObject) return;
    
    @autoreleasepool {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (id) A_GetByKey:(NSString*)key {
    @autoreleasepool {
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        if (![ud objectForKey:key])
        {
            return nil;
        } else {
            NSData* data = [ud objectForKey:key];
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
}
+ (void) A_CleanAll {
    @autoreleasepool {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        if (appDomain) {
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        } else {
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
            for (NSString *key in [defaultsDictionary allKeys]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [NSUserDefaults resetStandardUserDefaults];
    }
}

+ (void) A_Save:(id)dataObject toGroup:(NSString*)group andKey:(NSString*)key{
    if (!key || !dataObject) return;
    
    @autoreleasepool {
        NSUserDefaults* _file = [[NSUserDefaults alloc] initWithSuiteName:group];
        
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
        [_file setObject:data forKey:key];
        [_file synchronize];
    }
}
+ (id) A_GetByGroup:(NSString*)group andKey:(NSString*)key{
    @autoreleasepool {
        NSUserDefaults* _file = [[NSUserDefaults alloc] initWithSuiteName:group];
        if (!_file || ![_file objectForKey:key])
        {
            return nil;
        } else {
            NSData* data = [_file objectForKey:key];
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
}
+ (void) A_CleanAllInGroup: (NSString*)group{
    @autoreleasepool {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        
        NSUserDefaults* _file = [[NSUserDefaults alloc] initWithSuiteName:group];
        if (!_file) return;
        
        if (appDomain) {
            [_file removePersistentDomainForName:appDomain];
        } else {
            NSDictionary *defaultsDictionary = [_file dictionaryRepresentation];
            for (NSString *key in [defaultsDictionary allKeys]) {
                [_file removeObjectForKey:key];
            }
            [_file synchronize];
        }
    }
}

/** File operation **/
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

