//
//  A_ChainAnimation.m
//  A_ChainAnimation
//
//  Created by Animax Deng on 3/8/17.
//  Copyright © 2017 Animx. All rights reserved.
//

#import "A_ChainAnimation.h"

typedef enum : NSUInteger {
    animationType_AnimationBlock,
    animationType_CAAniamtion,
    animationType_Wait,
    animationType_Block,
} animationType;

@interface animationItem : NSObject

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval waitingTime;
@property (nonatomic) animationType  type;

@property (strong, nonatomic) NSMutableArray<CAAnimation *> *animations;
@property (strong, nonatomic) NSMutableArray<CAAnimation *> *animationsForMirror;

@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *properiesPreset;
@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *properiesSet;

@property (copy, nonatomic) void(^animationBlock)(void);
@property (copy, nonatomic) void(^completedBlock)(void);


@end

@implementation animationItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = 0.5f;
    }
    return self;
}

@end


typedef enum : NSUInteger {
    chainAnimtionModeAsync,
    chainAnimtionModeSync,
} chainAnimtionMode;

@interface A_ChainAnimation()

@property (nonatomic, strong) animationItem *syncingChainItem;

@property (nonatomic, strong) NSMutableArray<animationItem *> *chainItems;
@property (atomic) chainAnimtionMode currectMode;

@end

@implementation A_ChainAnimation

@dynamic thenSync;
@dynamic then;

#pragma mark - Private methods
- (void) _pushToChain {
    if (_syncingChainItem && (_syncingChainItem.waitingTime > 0 || _syncingChainItem.duration > 0 || (_syncingChainItem.animations && [_syncingChainItem.animations count] > 0) || _syncingChainItem.animations)) {
        [_chainItems addObject:_syncingChainItem];
    }
    _syncingChainItem = nil;
}
- (void) _addCALayerProperty:(NSString *)key value:(id)endValue animtionType:(A_AnimationType)type duration:(double)duration {
    
    CAKeyframeAnimation *animation = [A_Animation A_GenerateKeyframe:key Type:type Duration:duration FPS:A_AnimationFPS_high Start:[self.targetView.layer valueForKeyPath:key] End:endValue];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    if (self.currectMode == chainAnimtionModeSync) {
        if (_syncingChainItem) {
            _syncingChainItem.duration = _syncingChainItem.duration > duration ? _syncingChainItem.duration : duration;
            [_syncingChainItem.animations addObject:animation];
            
        } else {
            _syncingChainItem = [[animationItem alloc] init];
            _syncingChainItem.type = animationType_CAAniamtion;
            _syncingChainItem.duration = duration;
            _syncingChainItem.animations = [[NSMutableArray alloc] initWithObjects:animation, nil];
            _syncingChainItem.animationsForMirror = [[NSMutableArray alloc] init];
        }
        
        if (_syncingChainItem.properiesSet) {
            [_syncingChainItem.properiesSet setObject:endValue forKey:key];
        } else {
            _syncingChainItem.properiesSet = [[NSMutableDictionary alloc] initWithDictionary:@{key: endValue}];
        }
        
    } else {
        animationItem *item = [[animationItem alloc] init];
        item.duration = duration;
        item.type = animationType_CAAniamtion;
        item.animations = [[NSMutableArray alloc] initWithObjects:animation, nil];
        item.animationsForMirror = [[NSMutableArray alloc] init];
        item.properiesSet = [[NSMutableDictionary alloc] initWithDictionary:@{key: endValue}];
        [self.chainItems addObject:item];
    }
    
//    [self _setLayerProperty:key value:endValue];
}

- (void) _playAnimate:(BOOL)setPropertyValue {
    [self _pushToChain];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        for (animationItem *item in self.chainItems) {
            
            if (item.properiesPreset && [item.properiesPreset count]>0) {
                for (NSString *presetKey in item.properiesPreset) {
                    [self.targetView.layer setValue:[item.properiesPreset objectForKey:presetKey] forKeyPath:presetKey];
                }
            }
            
            switch (item.type) {
                case animationType_Block: {
                    if (item.completedBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            item.completedBlock();
                        });
                    }
                }
                    break;
                case animationType_Wait: {
                    dispatch_semaphore_t inflightSemaphore= dispatch_semaphore_create(0);
                    
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(item.waitingTime * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_semaphore_signal(inflightSemaphore);
                    });
                    
                    dispatch_semaphore_wait(inflightSemaphore, DISPATCH_TIME_FOREVER);
                }
                    break;
                case animationType_AnimationBlock: {
                    dispatch_semaphore_t inflightSemaphore= dispatch_semaphore_create(0);
                    
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(item.waitingTime * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            
                            [UIView animateWithDuration:item.duration animations:^{
                                if (item.animationBlock) {
                                    item.animationBlock();
                                }
                            } completion:^(BOOL finished) {
                                if (item.completedBlock) {
                                    item.completedBlock();
                                }
                                dispatch_semaphore_signal(inflightSemaphore);
                            }];
                            
                        });
                    });
                    
                    dispatch_semaphore_wait(inflightSemaphore, DISPATCH_TIME_FOREVER);
                }
                    break;
                case animationType_CAAniamtion: {
                    if (!self.targetView) {
                        break;
                    }
                    
                    dispatch_semaphore_t inflightSemaphore= dispatch_semaphore_create(0);
                    
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(item.waitingTime * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            
                            CALayer *mirrorLayer = nil;
                            if (item.animationsForMirror && [item.animationsForMirror count] > 0) {
                                UIGraphicsBeginImageContext(self.targetView.layer.frame.size);
                                [self.targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
                                UIImage *mirrorImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                mirrorLayer = [CALayer layer];
                                [mirrorLayer setContents:(id)mirrorImage.CGImage];
                                [mirrorLayer setPosition:self.targetView.center];
                                [mirrorLayer setFrame:CGRectMake(0, 0, self.targetView.frame.size.width, self.targetView.frame.size.height)];
                                [mirrorLayer setOpacity:0.5f];
                                [self.targetView.layer addSublayer:mirrorLayer];
                            }
                            
                            NSString *animationKey = [[NSUUID UUID] UUIDString];
                            [CATransaction begin]; {
                                
                                [CATransaction setCompletionBlock:^{
                                    
                                    if (setPropertyValue) { // Set CALayer property value after the animation finished
                                        for (NSString *valueKey in item.properiesSet) {
                                            [self.targetView.layer setValue:[item.properiesSet objectForKey:valueKey] forKeyPath:valueKey];
                                        }
                                    }
                                    
                                    [self.targetView.layer removeAnimationForKey:animationKey];
                                    dispatch_semaphore_signal(inflightSemaphore);
                                    [mirrorLayer removeFromSuperlayer];
                                }];
                                
                                if (item.animations && [item.animations count] > 0) {
                                    CAAnimationGroup *group = [CAAnimationGroup animation];
                                    [group setRemovedOnCompletion:NO];
                                    [group setFillMode:kCAFillModeForwards];
                                    
                                    [group setAnimations:item.animations];
                                    [group setDuration:item.duration];
                                    [self.targetView.layer addAnimation:group forKey:animationKey];
                                }
                                if (item.animationsForMirror && [item.animationsForMirror count] > 0) {
                                    
                                    CAAnimationGroup *group = [CAAnimationGroup animation];
                                    [group setRemovedOnCompletion:YES];
                                    [group setAnimations:item.animationsForMirror];
                                    [group setDuration:item.duration];
                                    [mirrorLayer addAnimation:group forKey:nil];
                                }
                                
                            } [CATransaction commit];
                            
                        });
                    });
                    
                    dispatch_semaphore_wait(inflightSemaphore, DISPATCH_TIME_FOREVER);
                }
                    break;
                default:
                    break;
            }
            
        }
    });
}
- (void) _addProperiesSetWithKey:(NSString *)key andValue:(id)value {
    if (self.currectMode == chainAnimtionModeSync) {
        if (_syncingChainItem.properiesSet) {
            [_syncingChainItem.properiesSet setObject:value forKey:key];
        } else {
            _syncingChainItem.properiesSet = [[NSMutableDictionary alloc] initWithDictionary:@{key: value}];
        }
    } else {
        NSMutableDictionary *dic = [self.chainItems lastObject].properiesSet;
        if (dic) {
            [dic setObject:value forKey:key];
        } else {
            dic = [[NSMutableDictionary alloc] initWithDictionary:@{key: value}];
        }
        [self.chainItems lastObject].properiesSet = dic;
    }
}

- (void) _presetCustomAnchorPoint:(CGPoint)anchorPoint {
    CGPoint newPoint = CGPointMake(self.targetView.layer.bounds.size.width * anchorPoint.x,
                                   self.targetView.layer.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.targetView.layer.bounds.size.width * self.targetView.layer.anchorPoint.x,
                                   self.targetView.layer.bounds.size.height * self.targetView.layer.anchorPoint.y);
    
    CGPoint position = self.targetView.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
//    self.targetView.layer.anchorPoint = anchorPoint;
//    self.targetView.layer.position = position;
    
    if (self.currectMode == chainAnimtionModeSync) {
        if (_syncingChainItem.properiesPreset) {
            [_syncingChainItem.properiesPreset setObject:[NSValue valueWithCGPoint:anchorPoint] forKey:@"anchorPoint"];
            [_syncingChainItem.properiesPreset setObject:[NSValue valueWithCGPoint:position] forKey:@"position"];
        } else {
            _syncingChainItem.properiesPreset = [[NSMutableDictionary alloc] initWithDictionary:@{@"anchorPoint": [NSValue valueWithCGPoint:anchorPoint],
                                                                                               @"position": [NSValue valueWithCGPoint:position]}];
        }
    } else {
        NSMutableDictionary *dic = [self.chainItems lastObject].properiesPreset;
        if (dic) {
            [dic setObject:[NSValue valueWithCGPoint:anchorPoint] forKey:@"anchorPoint"];
            [dic setObject:[NSValue valueWithCGPoint:position] forKey:@"position"];
        } else {
            dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"anchorPoint": [NSValue valueWithCGPoint:anchorPoint],
                                                                    @"position": [NSValue valueWithCGPoint:position]}];
        }
        [self.chainItems lastObject].properiesPreset = dic;
    }
}

#pragma mark - Initializtion
+ (A_ChainAnimation *)animate:(UIView *)target {
    A_ChainAnimation *animation = [[A_ChainAnimation alloc] init];
    animation.targetView = target;
    return animation;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _chainItems = [[NSMutableArray alloc] init];
        _currectMode = chainAnimtionModeAsync;
    }
    return self;
}

#pragma mark - Execute animate
- (void)play {
    [self _playAnimate:true];
}
- (void)playWithoutSet {
    [self _playAnimate:false];
}

#pragma mark - Dynamic Property
- (A_ChainAnimation *)thenSync {
    [self _pushToChain];
    _currectMode = chainAnimtionModeSync;
    return self;
}
- (A_ChainAnimation *)then {
    [self _pushToChain];
    _currectMode = chainAnimtionModeAsync;
    return self;
}

#pragma mark - Empty wait and block 
- (A_ChainAnimation *)wait:(NSTimeInterval)waitTime {
    [self _pushToChain];
    animationItem *item = [[animationItem alloc] init];
    item.waitingTime = waitTime;
    item.type = animationType_Wait;
    [self.chainItems addObject:item];
    return self;
}
- (A_ChainAnimation *)block:(void(^)(void))block {
    [self _pushToChain];
    animationItem *item = [[animationItem alloc] init];
    item.completedBlock = block;
    item.type = animationType_Block;
    [self.chainItems addObject:item];
    return self;
}

#pragma mark - UIView block animation set
- (A_ChainAnimation *)addAnimateWithDuration:(NSTimeInterval)duration aniamtion:(void(^)(void))animationBlock {
    return [self addAnimateWithWaitTime:0.0 duration:duration aniamtion:animationBlock completion:nil];
}
- (A_ChainAnimation *)addAnimateWithDuration:(NSTimeInterval)duration aniamtion:(void(^)(void))animationBlock completion:(void(^)(void))completionBlock {
    return [self addAnimateWithWaitTime:0.0 duration:duration aniamtion:animationBlock completion:completionBlock];
}
- (A_ChainAnimation *)addAnimateWithWaitTime:(NSTimeInterval)waitTime duration:(NSTimeInterval)duration aniamtion:(void(^)(void))animationBlock {
    return [self addAnimateWithWaitTime:waitTime duration:duration aniamtion:animationBlock completion:nil];
}
- (A_ChainAnimation *)addAnimateWithWaitTime:(NSTimeInterval)waitTime duration:(NSTimeInterval)duration aniamtion:(void(^)(void))animationBlock completion:(void(^)(void))completionBlock {
    
    [self _pushToChain];
    
    animationItem *item = [[animationItem alloc] init];
    item.duration = duration;
    item.waitingTime = waitTime;
    item.animationBlock = animationBlock;
    item.completedBlock = completionBlock;
    item.type = animationType_AnimationBlock;
    
    [self.chainItems addObject:item];
    
    return self;
}

#pragma mark - A_AnimationEffect animation set
- (A_ChainAnimation *)addAnimateWithEffect:(A_AnimationEffectType)effect type:(A_AnimationType)type duration:(NSTimeInterval)duration {
    
    if (self.currectMode == chainAnimtionModeSync) {
        
        if (_syncingChainItem) {
            _syncingChainItem.duration = _syncingChainItem.duration > duration ? _syncingChainItem.duration : duration;
            
            if ([A_Animation A_CheckIfMirrorEffect:effect]) {
                [_syncingChainItem.animationsForMirror addObject:[A_Animation A_GenerateEffect:[A_Animation A_ConvertMirrorEffect:effect] Duration:duration]];
            } else {
                [_syncingChainItem.animations addObject:[A_Animation A_GenerateEffect:effect Duration:duration]];
            }
            
        } else {
            _syncingChainItem = [[animationItem alloc] init];
            _syncingChainItem.type = animationType_CAAniamtion;
            _syncingChainItem.duration = duration;
            _syncingChainItem.animations = [[NSMutableArray alloc] init];
            _syncingChainItem.animationsForMirror = [[NSMutableArray alloc] init];
            
            if ([A_Animation A_CheckIfMirrorEffect:effect]) {
                [_syncingChainItem.animationsForMirror addObject:[A_Animation A_GenerateEffect:[A_Animation A_ConvertMirrorEffect:effect] Duration:duration]];
            } else {
                [_syncingChainItem.animations addObject:[A_Animation A_GenerateEffect:effect Duration:duration]];
            }
            
        }
        
    } else {
        animationItem *item = [[animationItem alloc] init];
        item.duration = duration;
        item.type = animationType_CAAniamtion;
        item.animations = [[NSMutableArray alloc] init];
        item.animationsForMirror = [[NSMutableArray alloc] init];
        
        if ([A_Animation A_CheckIfMirrorEffect:effect]) {
            [item.animationsForMirror addObject:[A_Animation A_GenerateEffect:[A_Animation A_ConvertMirrorEffect:effect] Duration:duration]];
        } else {
            [item.animations addObject:[A_Animation A_GenerateEffect:effect Duration:duration]];
        }
        
        [self.chainItems addObject:item];
    }
    return self;
}

#pragma mark - CALayer animation set
#pragma mark: Animation Layer Setting
- (A_ChainAnimation *) setAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"anchorPoint" value:[NSValue valueWithCGPoint:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"anchorPoint" value:[NSValue valueWithCGPoint:value] animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"backgroundColor" value:(id)value.CGColor animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"backgroundColor" value:(id)value.CGColor animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"opacity" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"opacity" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setPosition:(CGPoint)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"position" value:[NSValue valueWithCGPoint:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setPosition:(CGPoint)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"position" value:[NSValue valueWithCGPoint:value] animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setPositionX:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"position.x" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setPositionX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"position.x" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setPositionY:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"position.y" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setPositionY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"position.y" value:@(value) animtionType:type duration:duration];
    return self;
}

- (A_ChainAnimation *) setBounds:(CGRect)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"bounds" value:[NSValue valueWithCGRect:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setBounds:(CGRect)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"bounds" value:[NSValue valueWithCGRect:value] animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"borderWidth" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"borderWidth" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"borderColor" value:(id)value.CGColor animtionType:type duration:0.5f];
    
    return self;
}
- (A_ChainAnimation *) setBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"borderColor" value:(id)value.CGColor animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"contentsRect" value:[NSValue valueWithCGRect:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"contentsRect" value:[NSValue valueWithCGRect:value] animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"cornerRadius" value:@(value) animtionType:type duration:0.5f];
    [self.targetView.layer setMasksToBounds:YES];
    return self;
}
- (A_ChainAnimation *) setCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"cornerRadius" value:@(value) animtionType:type duration:duration];
    [self.targetView.layer setMasksToBounds:YES];
    return self;
}

- (A_ChainAnimation *) setShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"shadowOffset" value:[NSValue valueWithCGSize:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"shadowOffset" value:[NSValue valueWithCGSize:value] animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setShadowOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"shadowOpacity" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setShadowOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"shadowOpacity" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"shadowRadius" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"shadowRadius" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"sublayerTransform" value:[NSValue valueWithCATransform3D:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"sublayerTransform" value:[NSValue valueWithCATransform3D:value] animtionType:type duration:duration];
    return self;
}

- (A_ChainAnimation *) setZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"zPosition" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"zPosition" value:@(value) animtionType:type duration:duration];
    return self;
}

- (A_ChainAnimation *) setSize:(CGSize)value AnimtionType:(A_AnimationType)type{
    [self setSize:value AnimtionType:type Duraion:0.5f];
    return self;
}
- (A_ChainAnimation *) setSize:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    float widthDiff = (value.width - self.targetView.bounds.size.width) / 2.0f;
    float hightDiff = (value.height - self.targetView.bounds.size.height) / 2.0f;
    
    CGRect rect = CGRectMake(self.targetView.bounds.origin.x - widthDiff , self.targetView.bounds.origin.y - hightDiff, self.targetView.bounds.size.width + widthDiff, self.targetView.bounds.size.height + hightDiff);
    
    [self _addCALayerProperty:@"bounds" value:[NSValue valueWithCGRect:rect] animtionType:type duration:duration];
    return self;
}

- (A_ChainAnimation *) setTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type{
    [self _addCALayerProperty:@"transform" value:[NSValue valueWithCATransform3D:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    [self _addCALayerProperty:@"transform" value:[NSValue valueWithCATransform3D:value] animtionType:type duration:duration];
    return self;
}


#pragma mark: Animation Transform Setting
- (A_ChainAnimation *) setRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.rotation.x" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.rotation.x" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.rotation.y" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.rotation.y" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.rotation.z" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.rotation.z" value:@(value) animtionType:type duration:duration];
    return self;
}

- (A_ChainAnimation *) setScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.scale.x" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.scale.x" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.scale.y" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.scale.y" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.scale.z" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.scale.z" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setScale:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.scale" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setScale:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.scale" value:@(value) animtionType:type duration:duration];
    return self;
}

- (A_ChainAnimation *) setTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.translation.x" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.translation.x" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.translation.y" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.translation.y" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.translation.z" value:@(value) animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.translation.z" value:@(value) animtionType:type duration:duration];
    return self;
}
- (A_ChainAnimation *) setTranslation:(CGSize)value AnimtionType:(A_AnimationType)type {
    [self _addCALayerProperty:@"transform.translation" value:[NSValue valueWithCGSize:value] animtionType:type duration:0.5f];
    return self;
}
- (A_ChainAnimation *) setTranslation:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    [self _addCALayerProperty:@"transform.translation" value:[NSValue valueWithCGSize:value] animtionType:type duration:duration];
    return self;
}

#pragma mark: Custom Setting
- (A_ChainAnimation *) setLeftOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    return [self setLeftOblique:value AnimtionType:type Duraion:0.5f];
}
- (A_ChainAnimation *) setLeftOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m14 = (value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*-75)*M_PI/180.0, 0.0, 1.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self setTransform:concatenatedTransformation AnimtionType:type Duraion:duration];
    
    [self _presetCustomAnchorPoint:CGPointMake(0.0, 0.5)];
    
    return self;
}

- (A_ChainAnimation *) setRightOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    return [self setRightOblique:value AnimtionType:type Duraion:0.5f];
}
- (A_ChainAnimation *) setRightOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration{
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m14 = -(value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*75)*M_PI/180.0, 0.0, 1.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self setTransform:concatenatedTransformation AnimtionType:type Duraion:duration];
    [self _presetCustomAnchorPoint:CGPointMake(1.0, 0.5)];
    return self;
}

- (A_ChainAnimation *) setTopOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    return [self setTopOblique:value AnimtionType:type Duraion:0.5f];
}
- (A_ChainAnimation *) setTopOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m24 = (value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*75)*M_PI/180.0, 1.0, 0.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self setTransform:concatenatedTransformation AnimtionType:type Duraion:duration];
    [self _presetCustomAnchorPoint:CGPointMake(0.5, 0.0)];
    return self;
}

- (A_ChainAnimation *) setBottomOblique:(CGFloat)value AnimtionType:(A_AnimationType)type {
    return [self setBottomOblique:value AnimtionType:type Duraion:0.5f];
}
- (A_ChainAnimation *) setBottomOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration {
    if (value<0.0) { value = 0.0f; }
    else if (value>1.0) { value = 1.0f; }
    
    CATransform3D transformation = CATransform3DIdentity;
    transformation.m24 = -(value/100);
    
    CATransform3D yRotation = CATransform3DMakeRotation((value*-75)*M_PI/180.0, 1.0, 0.0, 0);
    CATransform3D concatenatedTransformation = CATransform3DConcat(yRotation, transformation);
    
    [self setTransform:concatenatedTransformation AnimtionType:type Duraion:duration];
    [self _presetCustomAnchorPoint:CGPointMake(0.5, 1.0)];
    return self;
}

- (A_ChainAnimation *) setRecoverOblique:(A_AnimationType)type {
    return [self setRecoverOblique:type Duraion:0.5f];
}
- (A_ChainAnimation *) setRecoverOblique:(A_AnimationType)type Duraion:(double)duration {
    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    
    CGPoint newPoint = CGPointMake(self.targetView.layer.bounds.size.width * anchorPoint.x,
                                   self.targetView.layer.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.targetView.layer.bounds.size.width * self.targetView.layer.anchorPoint.x,
                                   self.targetView.layer.bounds.size.height * self.targetView.layer.anchorPoint.y);
    
    CGPoint position = self.targetView.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    [self setTransform:CATransform3DIdentity AnimtionType:type Duraion:duration];
    
    [self _addProperiesSetWithKey:@"position" andValue:[NSValue valueWithCGPoint:position]];
    [self _addProperiesSetWithKey:@"anchorPoint" andValue:[NSValue valueWithCGPoint:anchorPoint]];
    
    return self;
}

//- (void)dealloc {
//    NSLog(@"dealloc");
//}

@end



