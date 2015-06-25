//
//  A_Animation.h
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface A_Animation : NSObject


typedef NS_ENUM(NSInteger, A_AnimationType) {
    A_AnimationType_default   =0,
    
    // http://easings.net/
    A_AnimationType_easeInQuint,
    A_AnimationType_easeOutQuint,
    A_AnimationType_easeInOutQuint,
    
    A_AnimationType_easeInCirc,
    A_AnimationType_easeOutCirc,
    A_AnimationType_easeInOutCirc,
    
    A_AnimationType_easeInBack,
    A_AnimationType_easeOutBack,
    A_AnimationType_easeInOutBack,
    
    A_AnimationType_easeInElastic,
    A_AnimationType_easeOutElastic,
    A_AnimationType_easeInOutElastic,
    
    A_AnimationType_easeInBounce,
    A_AnimationType_easeOutBounce,
    A_AnimationType_easeInOutBounce,
    
    // Springs
    A_AnimationType_spring,
    A_AnimationType_longSpring,
    A_AnimationType_bigSpring,
    A_AnimationType_bigLongSpring,
};
typedef NS_ENUM(NSUInteger, A_AnimationFPS) {
    A_AnimationFPS_low = 30,
    A_AnimationFPS_middle = 45,
    A_AnimationFPS_high = 60,
};
typedef NS_ENUM(NSUInteger, A_AnimationEffectType) {
    A_AnimationEffectType_flash =1,
    A_AnimationEffectType_pulse,
    A_AnimationEffectType_shakeHorizontal,
    A_AnimationEffectType_shakeVertical,
    A_AnimationEffectType_swing,
    A_AnimationEffectType_flipX,
    A_AnimationEffectType_flipY,
    
};




#pragma mark - Keyframe animation
+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_AnimationFPS)kpfs Start:(id)start End:(id)end;
+(CAAnimationGroup*)A_GenerateEffect:(A_AnimationEffectType)type Duration:(double)duration;


@end


