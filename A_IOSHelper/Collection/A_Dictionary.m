//
//  A_Dictionary.m
//  A_IOSHelper
//
//  Created by Animax Deng on 2/17/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import "A_Dictionary.h"

@implementation A_Dictionary {
    NSMapTable *_values;
    NSMutableOrderedSet *_keys;
}

- (instancetype)init {
    if (self = [super init]) {
        _values = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:0];
        _keys = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    if (self = [super init]) {
        _values = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:capacity];
        _keys = [[NSMutableOrderedSet alloc] initWithCapacity:capacity];
    }
    return self;
}

- (instancetype)copy {
    return [self mutableCopy];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_values forKey:@"values"];
    [coder encodeObject:_keys forKey:@"keys"];
}


- (NSArray *)allKeys {
    return [_keys array];
}
- (NSArray *)allValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (id key in _keys) {
        [values addObject:[_values objectForKey:key]];
    }
    return values;
}

- (NSUInteger)count {
    return [_keys count];
}

- (id)getKeyAtIndex:(NSInteger)index {
    return [_keys objectAtIndex:index];
}
- (id)objectForKey:(id)aKey {
//    NSUInteger index = [_keys indexOfObject:aKey];
//    if (index == NSNotFound) return nil;
    return [_values objectForKey:aKey];
}
- (id)objectAtIndex:(NSInteger)index {
    id key = [self getKeyAtIndex:index];
    return [self objectForKey:key];
}

- (NSEnumerator *)keyEnumerator {
    return [_keys objectEnumerator];
}
- (NSEnumerator *)reverseKeyEnumerator {
    return [_keys reverseObjectEnumerator];
}
- (NSEnumerator *)objectEnumerator {
    return [_values objectEnumerator];
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex {
    [self removeObjectForKey:aKey];
    
}
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (![_values objectForKey:aKey])
    {
        [_keys addObject:aKey];
    }
    [_values setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {
    NSUInteger index = [_keys indexOfObject:aKey];
    if (index == NSNotFound) return;
    
    [self removeObjectAtIndex:index];
}
- (void)removeObjectAtIndex:(NSUInteger)index {
    id key = [_keys objectAtIndex:index];
    if (!key) return;
    
    [_values removeObjectForKey:key];
    [_keys removeObjectAtIndex:index];
}
- (void)removeAllObjects {
    [_values removeAllObjects];
    [_keys removeAllObjects];
}

//- (void)sort {
////    _keys = [NSMutableOrderedSet alloc] initWithArray:
//    
//    [_keys sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        
//    }];
//}

@end
