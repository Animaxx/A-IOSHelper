//
//  NSMutableDictionary+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/24/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSMutableDictionary+A_Extension.h"
#import "A_CollectionHelper.h"

@implementation NSMutableDictionary(A_Extension)

- (void)A_Swap:(NSMutableDictionary*)dictionary{
    [A_CollectionHelper A_SwapDictionary:self With:dictionary];
}

@end
