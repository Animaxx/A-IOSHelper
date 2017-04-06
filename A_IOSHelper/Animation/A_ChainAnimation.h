//
//  A_ChainAnimation.h
//  A_ChainAnimation
//
//  Created by Animax Deng on 3/8/17.
//  Copyright © 2017 Animx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "A_Animation.h"
#import "A_AnimationEnumeration.h"
#import "A_AnimationKeyframeProvider.h"
#import "CALayer+A_Animation.h"
#import "UIView+A_Animation.h"

@interface A_ChainAnimation : NSObject

#pragma mark - Dynamic Properties
/**
 Target object
 */
@property (weak, nonatomic) UIView *targetView;

/**
 Set to sync, adding animations after this set will be rander at same time.
 */
@property (assign, readonly) A_ChainAnimation *thenSync;

/**
 Set to async.
 */
@property (assign, readonly) A_ChainAnimation *then;

#pragma mark - Initializtion
/**
 Initialize animation with target UIView

 @param target Target UIView
 @return A_ChainAnimation
 */
+ (A_ChainAnimation *)animate:(UIView *)target;

#pragma mark - Execute animate
/**
 Run the whole animations chain.
 */
- (void)play;

/**
 Run the whole animations chain without set property value.
 */
- (void)playWithoutSet;


#pragma mark - Empty wait and block

/**
 Add waiting block to animations chain

 @param waitTime wait for seconds
 @return A_ChainAnimation
 */
- (A_ChainAnimation *)wait:(NSTimeInterval)waitTime;

/**
 Add open block to animations chain

 @param block Action block
 @return A_ChainAnimtion
 */
- (A_ChainAnimation *)block:(void(^)(void))block;

#pragma mark - UIView block animation set

/**
 Add UIView Animation block to animations chain
 
 @param duration Animation duration time
 @param animationBlock Animate block
 @return A_ChainAnimtion
 */
- (A_ChainAnimation *)addAnimateWithDuration:(NSTimeInterval)duration aniamtion:(void(^)(void))animationBlock;

/**
 Add UIView Animation block to animations chain
 
 @param duration Animation duration time
 @param animationBlock Animate block
 @param completionBlock completed block
 @return A_ChainAnimtion
 */
- (A_ChainAnimation *)addAnimateWithDuration:(NSTimeInterval)duration aniamtion:(void(^)(void))animationBlock completion:(void(^)(void))completionBlock;

/**
 Add UIView Animation block to animations chain
 
 @param waitTime Waiting time before aniamtion
 @param duration Animation duration time
 @param animationBlock Animate block
 @return A_ChainAnimtion
 */
- (A_ChainAnimation *)addAnimateWithWaitTime:(NSTimeInterval)waitTime duration:(NSTimeInterval)duration aniamtion:(void(^)(void))animationBlock;


/**
 Add UIView Animation block to animations chain

 @param waitTime Waiting time before aniamtion
 @param duration Animation duration time
 @param animationBlock Animate block
 @param completionBlock completed block
 @return A_ChainAnimtion
 */
- (A_ChainAnimation *)addAnimateWithWaitTime:(NSTimeInterval)waitTime
                                    duration:(NSTimeInterval)duration
                                   aniamtion:(void(^)(void))animationBlock
                                  completion:(void(^)(void))completionBlock;

#pragma mark - A_AnimationEffect animation set

/**
 Add custom effection animation to animations chain

 @param effect Animation effecting type
 @param type Animation moving type
 @param duration Animation duration
 @return A_ChainAnimtion
 */
- (A_ChainAnimation *)addAnimateWithEffect:(A_AnimationEffectType)effect type:(A_AnimationType)type duration:(NSTimeInterval)duration;

#pragma mark - CALayer animation set
#pragma mark: Animation Layer Setting
- (A_ChainAnimation *) setAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setAnchorPoint:(CGPoint)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setBackgroundColor:(UIColor*)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setPosition:(CGPoint)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setPosition:(CGPoint)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setPositionX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setPositionX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setPositionY:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setPositionY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

- (A_ChainAnimation *) setBounds:(CGRect)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setBounds:(CGRect)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setBorderWidth:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setBorderColor:(UIColor*)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setContentsRect:(CGRect)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setCornerRadius:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

- (A_ChainAnimation *) setShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setShadowOffset:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setShadowOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setShadowOpacity:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setShadowRadius:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setSublayerTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

- (A_ChainAnimation *) setZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setZPosition:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

- (A_ChainAnimation *) setSize:(CGSize)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setSize:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

- (A_ChainAnimation *) setTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setTransform:(CATransform3D)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

#pragma mark - 
#pragma mark: Animation Transform Setting
- (A_ChainAnimation *) setRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setRotationX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setRotationY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setRotationZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

- (A_ChainAnimation *) setScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setScaleX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setScaleY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setScaleZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setScale:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setScale:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

- (A_ChainAnimation *) setTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setTranslationX:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setTranslationY:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setTranslationZ:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;
- (A_ChainAnimation *) setTranslation:(CGSize)value AnimtionType:(A_AnimationType)type;
- (A_ChainAnimation *) setTranslation:(CGSize)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

#pragma mark -
#pragma mark: Custom Setting
/**
 Set to left oblique

 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setLeftOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;

/**
 Set to left oblique

 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @param duration Animating duration
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setLeftOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

/**
 Set to right oblique
 
 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setRightOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;
/**
 Set to right oblique
 
 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @param duration Animating duration
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setRightOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

/**
 Set to top oblique
 
 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setTopOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;

/**
 Set to top oblique
 
 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @param duration Animating duration
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setTopOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;

/**
 Set to bottom oblique
 
 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setBottomOblique:(CGFloat)value AnimtionType:(A_AnimationType)type;
/**
 Set to bottom oblique
 
 @param value [0 ... 1.0], 0 means no change
 @param type AnimationType
 @param duration Animating duration
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setBottomOblique:(CGFloat)value AnimtionType:(A_AnimationType)type Duraion:(double)duration;


/**
 Reset oblique

 @param type AnimationType
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setRecoverOblique:(A_AnimationType)type;

/**
 Reset oblique

 @param type AnimationType
 @param duration Animating duration
 @return A_ChainAnimation
 */
- (A_ChainAnimation *) setRecoverOblique:(A_AnimationType)type Duraion:(double)duration;

@end
