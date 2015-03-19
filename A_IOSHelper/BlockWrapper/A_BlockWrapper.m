//
//  A_BlockWrapper.m
//  A_IOSHelper
//
//  Created by Animax on 3/11/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_BlockWrapper.h"

@interface A_BlockWrapper()
@property (readwrite, nonatomic) void *block;
@property (weak, nonatomic) id arg;
@end


@implementation A_BlockWrapper

+ (A_BlockWrapper*) A_Init: (void *)block {
    A_BlockWrapper* _blockWrapper = [[A_BlockWrapper alloc] init];
    _blockWrapper.block = block;
    return _blockWrapper;
}
+ (A_BlockWrapper*) A_Init: (void *)block WithObj: (id)obj {
    A_BlockWrapper* _blockWrapper = [[A_BlockWrapper alloc] init];
    _blockWrapper.block = block;
    _blockWrapper.arg = obj;
    return _blockWrapper;
}

- (void) A_Execute {
    if (self.block) {
        ((void (^)(id arg))self.block)(self.arg);
    }
}
- (void) A_Execute: (id)obj {
    if (self.block) {
        ((void (^)(id obj,id arg))self.block)(obj,self.arg);
    }
}
- (void) A_Execute: (id)obj WithObj:(id)obj2{
    if (self.block) {
        ((void (^)(id obj1,id obj2,id arg))self.block)(obj,obj2,self.arg);
    }
}

@end
