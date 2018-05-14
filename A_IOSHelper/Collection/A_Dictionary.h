//
//  A_Dictionary.h
//  A_IOSHelper
//
//  Created by Animax Deng on 2/17/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_Dictionary<__covariant KeyType,__covariant ObjectType> : NSMutableDictionary<KeyType, ObjectType>

- (ObjectType)getKeyAtIndex:(NSInteger)index;
- (ObjectType)objectAtIndex:(NSInteger)index;

- (NSEnumerator *)reverseKeyEnumerator;
- (void)orderBy:(NSComparator NS_NOESCAPE)comparator;

- (void)insertObject:(ObjectType)anObject forKey:(KeyType)aKey atIndex:(NSUInteger)anIndex;
- (void)replaceObject:(ObjectType)anObject atIndex:(NSUInteger)anIndex;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (KeyType)lastKey;
- (KeyType)firstKey;

- (ObjectType)lastObject;
- (ObjectType)firstObject;

@end
