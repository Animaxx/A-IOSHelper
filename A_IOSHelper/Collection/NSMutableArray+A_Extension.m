//
//  NSMutableArray+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/24/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSMutableArray+A_Extension.h"

@implementation NSMutableArray(A_Extension)

- (void)A_Swap:(NSMutableArray*)array{
    if (!self || !array) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Error occur in swap array>  \r\n Can not swap with nil \r\n -------- \r\n\r\n");
        return;
    }
    
    NSUInteger length = [self count];
    if ([array count] < length) length = [array count];
    
    for (NSUInteger i=0; i<length; i++) {
        id temp = [array objectAtIndex:i];
        [array replaceObjectAtIndex:i withObject:[[self objectAtIndex:i] copy]];
        [self replaceObjectAtIndex:i withObject:temp];
    }
}

@end
