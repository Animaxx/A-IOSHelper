//
//  NSObject+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax Deng on 6/30/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import "NSObject+A_Extension.h"
#import <objc/runtime.h>

@implementation NSObject (A_Extension)

-(void) A_SetProperty:(id)obj to:(id)key with:(A_ExtraPropertPolicy)policy {
    objc_AssociationPolicy p = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
    switch (policy) {
        case A_ExtraPropertPolicy_Assign:
            p = OBJC_ASSOCIATION_ASSIGN;
            break;
        case A_ExtraPropertPolicy_Strong_Nonatomic:
            p = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
            break;
        case A_ExtraPropertPolicy_Copy_Nonatomic:
            p = OBJC_ASSOCIATION_COPY_NONATOMIC;
            break;
        case A_ExtraPropertPolicy_Strong_Atomic:
            p = OBJC_ASSOCIATION_RETAIN;
            break;
        case A_ExtraPropertPolicy_Copy_Atomic:
            p = OBJC_ASSOCIATION_COPY;
            break;
        default:
            break;
    }
    objc_setAssociatedObject(self, @selector(key), obj, p);
}
-(void) A_SetProperty:(id)obj to:(id)key {
    [self A_SetProperty:obj to:key with:A_ExtraPropertPolicy_Strong_Nonatomic];
}
-(id) A_GetProperty:(id)key {
    return objc_getAssociatedObject(self, @selector(key));
}

@end
