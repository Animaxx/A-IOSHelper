//
//  A_Dictionary.h
//  A_IOSHelper
//
//  Created by Animax Deng on 2/17/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_Dictionary<__covariant KeyType,__covariant ObjectType> : NSMutableDictionary<KeyType, ObjectType>

- (id)getKeyAtIndex:(NSInteger)index;
- (id)objectAtIndex:(NSInteger)index;

- (NSEnumerator *)reverseKeyEnumerator;

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;
- (void)replaceObject:(id)anObject atIndex:(NSUInteger)anIndex;

- (void)removeObjectAtIndex:(NSUInteger)index; 

@end
