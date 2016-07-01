//
//  NSObject+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/30/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, A_ExtraPropertPolicy) {
    A_ExtraPropertPolicy_Assign               = 0,
    A_ExtraPropertPolicy_Strong_Nonatomic,
    A_ExtraPropertPolicy_Copy_Nonatomic,
    A_ExtraPropertPolicy_Strong_Atomic,
    A_ExtraPropertPolicy_Copy_Atomic,
};

@interface NSObject (A_Extension)

-(void) A_SetProperty:(id)obj to:(id)key with:(A_ExtraPropertPolicy)policy;
-(void) A_SetProperty:(id)obj to:(id)key;
-(id) A_GetProperty:(id)key;

@end
