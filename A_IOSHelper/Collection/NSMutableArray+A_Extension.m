//
//  NSMutableArray+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/24/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSMutableArray+A_Extension.h"
#import "A_CollectionHelper.h"

@implementation NSMutableArray(A_Extension)

- (void)A_Swap:(NSMutableArray*)array{
    [A_CollectionHelper A_SwapArray:self With:array];
}

@end
