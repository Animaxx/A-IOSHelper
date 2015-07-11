//
//  NSObject+A_KVO_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSObject+A_KVO_Extension.h"
#import <objc/runtime.h>

#pragma mark - Observer Head
@interface A_Observer : NSObject

@property (assign, nonatomic) NSObject *observedObject;
@property (assign, nonatomic) NSString *key;
@property (nonatomic) id param;
@property (readwrite, nonatomic) void* block;

+ (A_Observer*) A_CreateObserver:(void (^)(id itself, NSDictionary* change, id param))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option param:(id)parm;
+ (A_Observer*) A_CreateObserver:(void (^)(id itself, NSDictionary* change))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option;

@end

#pragma mark - BindingObserver Head
typedef id(^BindObserverBlock)(id value);

@interface A_BindingObserver : NSObject

@property (assign, nonatomic) NSObject *observedObject;
@property (assign, nonatomic) NSString *fromKey;
@property (assign, nonatomic) NSString *toKey;
@property (weak, nonatomic) id target;
@property (readwrite, copy) BindObserverBlock bindBlock;

+ (A_BindingObserver*) A_CreateObserver:(BindObserverBlock)block
                         observedObject:(NSObject*)observedObject
                                   from:(NSString*)from
                                     to:(NSString*)to;
+ (A_BindingObserver*) A_CreateObserver:(BindObserverBlock)block
                         observedObject:(NSObject*)observedObject
                                   from:(NSString*)from
                                toTager:(id)tager
                                  toKey:(NSString*)toKey;

@end

#pragma mark - KVO Extension Implement

@implementation NSObject (A_KVO_Extension)

static char AObservationsCharKey;
static char ABindCharKey;

- (NSMutableArray*)_getObservers {
    NSMutableArray *observations = objc_getAssociatedObject(self, &AObservationsCharKey);
    if ( observations == nil ) {
        observations = [NSMutableArray array];
        objc_setAssociatedObject(self, &AObservationsCharKey, observations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observations;
}
- (NSMutableArray*)_getBindObservers {
    NSMutableArray *observations = objc_getAssociatedObject(self, &ABindCharKey);
    if ( observations == nil ) {
        observations = [NSMutableArray array];
        objc_setAssociatedObject(self, &ABindCharKey, observations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observations;
}


-(void) A_AddObserver:(NSString*)key Param:(id)param block:(void (^)(id itself, NSDictionary* change, id param))block{
    [self A_AddObserverWithOption: NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                              Key:key
                            Param:param
                            block:block];
}
-(void) A_AddObserver:(NSString*)key block:(void (^)(id itself, NSDictionary* change))block {
    [self A_AddObserverWithOption: NSKeyValueObservingOptionOld |NSKeyValueObservingOptionNew
                              Key:key
                            block:block];
}

-(void) A_AddObserverWithOption:(NSKeyValueObservingOptions)option Key:(NSString*)key Param:(id)param block:(void (^)(id itself, NSDictionary* change, id param))block{
    if (!key || key.length <= 0) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <KVO Helper> \r\n Cannot observe an empty key  \r\n -------- \r\n\r\n");
        return;
    }
    
    [[self _getObservers] addObject:[A_Observer A_CreateObserver:block
                                                  observedObject:self
                                                             key:key
                                                          option:option param:param]];
}
-(void) A_AddObserverWithOption:(NSKeyValueObservingOptions)option Key:(NSString*)key block:(void (^)(id itself, NSDictionary* change))block{
    if (!key || key.length <= 0) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <KVO Helper - Add Observer> \r\n Cannot observe an empty key  \r\n -------- \r\n\r\n");
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

-(void) A_Bind:(NSString*)key To:(NSString*)to {
    [self A_Bind:key To:to Convert:nil];
}
-(void) A_Bind:(NSString*)key To:(NSString*)to Convert:(id (^)(id value))convertBlock {
    if (!key || key.length <= 0) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <KVO Helper - Binding> \r\n Cannot bind an empty key  \r\n -------- \r\n\r\n");
        return;
    }
    
    [[self _getBindObservers] addObject:[A_BindingObserver A_CreateObserver:convertBlock observedObject:self from:key to:to]];
}
-(void) A_Bind:(NSString*)key ToTager:(id)toTager AndKey:(NSString*)toKey {
    [self A_Bind:key ToTager:toTager AndKey:toKey Convert:nil];
}
-(void) A_Bind:(NSString*)key ToTager:(id)toTager AndKey:(NSString*)toKey Convert:(id (^)(id value))convertBlock {
    if (!key || key.length <= 0) {
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <KVO Helper - Binding> \r\n Cannot bind an empty key  \r\n -------- \r\n\r\n");
        return;
    }
    
    [[self _getBindObservers] addObject:[A_BindingObserver A_CreateObserver:convertBlock observedObject:self from:key toTager:toTager toKey:toKey]];
}

-(void) A_RemoveBinding: (NSString*)fromKey {
    NSIndexSet *indexes = [[self _getBindObservers] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isMemberOfClass:[A_BindingObserver class]] && [((A_BindingObserver*)obj).observedObject isEqual:self] && [fromKey isEqualToString:((A_BindingObserver*)obj).fromKey];
    }];
    if ( indexes.count > 0 ) {
        [[self _getBindObservers] removeObjectsAtIndexes:indexes];
    }
}

- (void) A_RemoveObservings {
    if (objc_getAssociatedObject(self, &AObservationsCharKey)) {
        objc_removeAssociatedObjects(self);
    }
    if (objc_getAssociatedObject(self, &ABindCharKey)) {
        objc_removeAssociatedObjects(self);
    }
}
//- (void)dealloc {
//    [self A_RemoveAllObservers];
//    [self A_RemoveAllBinding];
//}

@end

#pragma mark - Observer Class
@implementation A_Observer

bool _blockWithParam;
+ (A_Observer*) A_CreateObserver:(void (^)(id itself, NSDictionary* change, id param))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option param:(id)parm{
    A_Observer* _observer = [[A_Observer alloc] init];
    [_observer setObservedObject:observedObject];
    [_observer setKey:key];
    [_observer setParam:parm];
    [_observer setBlock:(__bridge void *)(block)];
    _blockWithParam = YES;
    
    [observedObject addObserver:_observer forKeyPath:key options:option context:nil];
    return _observer;
}
+ (A_Observer*) A_CreateObserver:(void (^)(id itself, NSDictionary* change))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option {
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
    [self observationInfo];
    
    if (self.observedObject) {
        @try {
            [self.observedObject removeObserver:self forKeyPath:self.key];
        }
        @catch (NSException *exception) {
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <KVO Helper> \r\n Error while remove observer %@ \r\n -------- \r\n\r\n", exception.reason);
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.block) {
        if (_blockWithParam) {
            ((void (^)(NSObject* itself, NSDictionary* change, id param))self.block)(self.observedObject,change,[self param]);
        } else {
            ((void (^)(NSObject* itself, NSDictionary* change))self.block)(self.observedObject,change);
        }
    }
}

@end

#pragma mark - BindingObserver Class
@implementation A_BindingObserver

bool _withTager;
+ (A_BindingObserver*) A_CreateObserver:(BindObserverBlock)block
                         observedObject:(NSObject*)observedObject
                                   from:(NSString*)from
                                     to:(NSString*)to {
    A_BindingObserver* _observer = [[A_BindingObserver alloc] init];
    [_observer setObservedObject:observedObject];
    [_observer setBindBlock:block];
    [_observer setFromKey:from];
    [_observer setToKey:to];
    _withTager = NO;
    
    [observedObject addObserver:_observer forKeyPath:from options:NSKeyValueObservingOptionNew context:nil];
    return _observer;
}
+ (A_BindingObserver*) A_CreateObserver:(BindObserverBlock)block
                         observedObject:(NSObject*)observedObject
                                   from:(NSString*)from
                                toTager:(id)tager
                                  toKey:(NSString*)toKey {
    A_BindingObserver* _observer = [[A_BindingObserver alloc] init];
    [_observer setObservedObject:observedObject];
    [_observer setBindBlock:block];
    [_observer setFromKey:from];
    [_observer setToKey:toKey];
    [_observer setTarget:tager];
    _withTager = YES;
    
    [observedObject addObserver:_observer forKeyPath:from options:NSKeyValueObservingOptionNew context:nil];
    return _observer;
}

- (void)dealloc {
    if (self.observedObject) {
        @try {
            [self.observedObject removeObserver:self forKeyPath:self.fromKey];
        }
        @catch (NSException *exception) {
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <KVO Helper> \r\n Error while remove observer %@ \r\n -------- \r\n\r\n", exception.reason);
        }
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    id _newValue = self.bindBlock ? self.bindBlock([change objectForKey:@"new"]): [change objectForKey:@"new"];
    if (_withTager) {
        if (self.target) {
            [self.target setValue:_newValue forKeyPath:self.toKey];
        } else {
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <KVO Helper> \r\n From %@->%@ to Tager object->%@, the binding tager already repleased. \r\n -------- \r\n\r\n", self.observedObject, self.fromKey, self.toKey);
        }
    } else {
        [self.observedObject setValue:_newValue forKeyPath:self.toKey];
    }
}


@end


