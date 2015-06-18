//
//  A_KeyframeProvider.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, A_AnimationType) {
    A_AnimationType_easeInQuint   =1,
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
    
    A_AnimationType_spring,
    A_AnimationType_longSpring,
    A_AnimationType_bigSpring,
    A_AnimationType_bigLongSpring,
};
typedef NS_ENUM(NSUInteger, A_Animation_kFPS) {
    A_Animation_kFPS_low = 30,
    A_Animation_kFPS_middle = 45,
    A_Animation_kFPS_high = 60,
};



@interface A_KeyframeProvider : NSObject

+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_Animation_kFPS)kpfs Start:(id)start End:(id)end;

@end
