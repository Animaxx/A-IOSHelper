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


@property (weak, nonatomic) NSObject *observedObject;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) id param;
@property (readwrite, nonatomic) void* block;

+ (A_Observer*) A_CreateObserver:(void (^)(id object, NSDictionary* change, id param))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option param:(id)parm;
+ (A_Observer*) A_CreateObserver:(void (^)(id object, NSDictionary* change))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option;

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

-(void) A_AddObserver:(void (^)(id object, NSDictionary* change, id param))block Key:(NSString*)key Option:(NSKeyValueObservingOptions)option Param:(id)param{
    [[self _getObservers] addObject:[A_Observer A_CreateObserver:block observedObject:self key:key option:option param:param]];
}
-(void) A_AddObserver:(void (^)(id object, NSDictionary* change))block Key:(NSString*)key Option:(NSKeyValueObservingOptions)option{
    [[self _getObservers] addObject:[A_Observer A_CreateObserver:block observedObject:self key:key option:option]];
}

@end


@implementation A_Observer


+ (A_Observer*) A_CreateObserver:(void (^)(id object, NSDictionary* change, id param))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option param:(id)parm{
    A_Observer* _observer = [[A_Observer alloc] init];
    [_observer setObservedObject:observedObject];
    [_observer setKey:key];
    [_observer setParam:parm];
    [_observer setBlock:(__bridge void *)(block)];
    
    [observedObject addObserver:observedObject forKeyPath:key options:option context:nil];
    return _observer;
}
+ (A_Observer*) A_CreateObserver:(void (^)(id object, NSDictionary* change))block observedObject:(NSObject*)observedObject key:(NSString*)key option:(NSKeyValueObservingOptions)option {
    A_Observer* _observer = [[A_Observer alloc] init];
    [_observer setObservedObject:observedObject];
    [_observer setKey:key];
    [_observer setParam:nil];
    [_observer setBlock:(__bridge void *)(block)];
    
    [observedObject addObserver:observedObject forKeyPath:key options:option context:nil];
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
    
}

@end


