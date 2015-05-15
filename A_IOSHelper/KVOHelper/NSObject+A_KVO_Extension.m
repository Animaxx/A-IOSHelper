//
//  NSObject+A_KVO_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSObject+A_KVO_Extension.h"
#import <objc/runtime.h>

@interface A_Observer : NSObject

@property (strong, nonatomic) NSObject *observedObject;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) id param;
@property (readwrite, nonatomic) void* block;

+ (A_Observer*) A_CreateObserver:(void (^)(NSObject* itself, NSDictionary* change, id param))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option param:(id)parm;
+ (A_Observer*) A_CreateObserver:(void (^)(NSObject* itself, NSDictionary* change))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option;

@end

static char AObservationsCharKey;

@implementation NSObject (A_KVO_Extension)

- (NSMutableArray*)_getObservers {
    NSMutableArray *observations = objc_getAssociatedObject(self, &AObservationsCharKey);
    if ( observations == nil ) {
        observations = [NSMutableArray array];
        objc_setAssociatedObject(self, &AObservationsCharKey, observations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observations;
}

-(void) A_AddObserver:(NSString*)key Option:(NSKeyValueObservingOptions)option Param:(id)param block:(void (^)(NSObject* itself, NSDictionary* change, id param))block{
    if (!key || key.length <= 0) {
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <KVO Helper> \r\n Cannot observe an empty key ");
        return;
    }
    
    [[self _getObservers] addObject:[A_Observer A_CreateObserver:block observedObject:self key:key option:option param:param]];
}
-(void) A_AddObserver:(NSString*)key Option:(NSKeyValueObservingOptions)option block:(void (^)(NSObject* itself, NSDictionary* change))block{
    if (!key || key.length <= 0) {
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <KVO Helper> \r\n Cannot observe an empty key ");
        return;
    }
    
    [[self _getObservers] addObject:[A_Observer A_CreateObserver:block observedObject:self key:key option:option]];
}
-(void) A_RemoveObserver: (NSString*)key {
    NSIndexSet *indexes = [[self _getObservers] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isMemberOfClass:[A_Observer class]] && [((A_Observer*)obj).observedObject isEqual:self] && [key isEqualToString:((A_Observer*)obj).key];
    }];
    if ( indexes.count > 0 ) {
        [[self _getObservers] removeObjectsAtIndexes:indexes];
    }
}

@end


@implementation A_Observer

bool _blockWithParam;
+ (A_Observer*) A_CreateObserver:(void (^)(NSObject* itself, NSDictionary* change, id param))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option param:(id)parm{
    A_Observer* _observer = [[A_Observer alloc] init];
    [_observer setObservedObject:observedObject];
    [_observer setKey:key];
    [_observer setParam:parm];
    [_observer setBlock:(__bridge void *)(block)];
    _blockWithParam = YES;
    
    [observedObject addObserver:_observer forKeyPath:key options:option context:nil];
    return _observer;
}
+ (A_Observer*) A_CreateObserver:(void (^)(NSObject* itself, NSDictionary* change))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option {
    A_Observer* _observer = [[A_Observer alloc] init];
    [_observer setObservedObject:observedObject];
    [_observer setKey:key];
    [_observer setParam:nil];
    [_observer setBlock:(__bridge void *)(block)];
    _blockWithParam = NO;
    
    [observedObject addObserver:_observer forKeyPath:key options:option context:nil];
    return _observer;
}

- (void)dealloc {
    if ( self.observedObject ) {
        @try {
            [self.observedObject removeObserver:self forKeyPath:self.key];
        }
        @catch (NSException *exception) {
            NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <KVO Helper> \r\n Error while remove observer %@", exception.reason);
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.block) {
        if (_blockWithParam) {
            ((void (^)(NSObject* itself, NSDictionary* change, id param))self.block)(self.observedObject,change,self.param);
        } else {
            ((void (^)(NSObject* itself, NSDictionary* change))self.block)(self.observedObject,change);
        }
        
    }
}

@end


