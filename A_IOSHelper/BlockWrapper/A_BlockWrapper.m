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
@end


@implementation A_BlockWrapper

+ (A_BlockWrapper*) A_Init: (void *)block {
    A_BlockWrapper* _blockWrapper = [[A_BlockWrapper alloc] init];
    _blockWrapper.block = block;
    return _blockWrapper;
}

- (void) A_Execute {
    if (self.block) {
        ((void (^)(void))self.block)();
    }
}
- (void) A_Execute: (id)obj {
    if (self.block) {
        ((void (^)(id))self.block)(obj);
    }
}
- (void) A_Execute: (id)obj WithObj:(id)obj2{
    if (self.block) {
        ((void (^)(id,id))self.block)(obj,obj2);
    }
}

@end
