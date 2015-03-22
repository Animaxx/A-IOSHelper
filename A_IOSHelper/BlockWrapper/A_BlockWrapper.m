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
    return [[A_BlockWrapper alloc] init:block];
}
+ (A_BlockWrapper*) A_Init: (void *)block WithObj: (id)obj {
    return [[A_BlockWrapper alloc] init:block WithObj:obj];
}

- (A_BlockWrapper*) init: (void *)block {
    if ((self = [super init])) {
        self.block = block;
    }
    return self;
}
- (A_BlockWrapper*) init: (void *)block WithObj: (id)obj{
    if ((self = [super init])) {
        self.block = block;
        self.arg = obj;
    }
    return self;
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
