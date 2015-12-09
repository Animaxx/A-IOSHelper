//
//  A_AnimationEnumeration.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/26/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, A_AnimationFPS) {
    A_AnimationFPS_low = 30,
    A_AnimationFPS_middle = 45,
    A_AnimationFPS_high = 60,
};

typedef NS_ENUM(NSInteger, A_AnimationType) {
    A_AnimationType_noEffect   =0,
    
    // Springs
    A_AnimationType_spring,
    A_AnimationType_longSpring,
    A_AnimationType_bigSpring,
    A_AnimationType_bigLongSpring,
    
    // http://easings.net/
    A_AnimationType_easeInSine,
    A_AnimationType_easeOutSine,
    A_AnimationType_easeInOutSine,
    
    A_AnimationType_easeInQuad,
    A_AnimationType_easeOutQuad,
    A_AnimationType_easeInOutQuad,
    
    A_AnimationType_easeInCubic,
    A_AnimationType_easeOutCubic,
    A_AnimationType_easeInOutCubic,
    
    A_AnimationType_easeInQuart,
    A_AnimationType_easeOutQuart,
    A_AnimationType_easeInOutQuart,
    
    A_AnimationType_easeInQuint,
    A_AnimationType_easeOutQuint,
    A_AnimationType_easeInOutQuint,
    
    
    A_AnimationType_easeInExpo,
    A_AnimationType_easeOutExpo,
    A_AnimationType_easeInOutExpo,
    
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
};

typedef NS_ENUM(NSUInteger, A_AnimationEffectType) {
    // emphasize effect
    A_AnimationEffectType_flash                 =1,
    A_AnimationEffectType_press                 =2,
    A_AnimationEffectType_pulse                 =3,
    A_AnimationEffectType_shakeHorizontal       =4,
    A_AnimationEffectType_shakeVertical         =5,
    A_AnimationEffectType_swing                 =6,
    A_AnimationEffectType_wobble                =7,
    A_AnimationEffectType_quake                 =8,
    A_AnimationEffectType_squeeze               =9,
    
    // shift effect
    A_AnimationEffectType_flipX                 =101,
    A_AnimationEffectType_flipY                 =102,
    A_AnimationEffectType_flipLeft              =103,
    A_AnimationEffectType_flipRight             =104,
    
    // appear effect
    A_AnimationEffectType_flipInX               =201,
    A_AnimationEffectType_flipInY               =202,
    A_AnimationEffectType_fadeIn                =203,
    A_AnimationEffectType_zoomIn                =204,
    A_AnimationEffectType_cardIn                =205,
    // disappear effect
    A_AnimationEffectType_flipOutX              =301,
    A_AnimationEffectType_flipOutY              =302,
    A_AnimationEffectType_fadeOut               =303,
    A_AnimationEffectType_zoomOut               =304,
    A_AnimationEffectType_cardOut               =305,
    
    
    
    // emphasize effect
    A_AnimationEffectType_mirror_flash          =1001,
    A_AnimationEffectType_mirror_press          =1002,
    A_AnimationEffectType_mirror_pulse          =1003,
    A_AnimationEffectType_mirror_shakeHorizontal    =1004,
    A_AnimationEffectType_mirror_shakeVertical  =1005,
    A_AnimationEffectType_mirror_swing          =1006,
    A_AnimationEffectType_mirror_wobble         =1007,
    A_AnimationEffectType_mirror_quake          =1008,
    A_AnimationEffectType_mirror_squeeze        =1009,
    
    // shift effect
    A_AnimationEffectType_mirror_flipX          =1101,
    A_AnimationEffectType_mirror_flipY          =1102,
    A_AnimationEffectType_mirror_flipLeft       =1103,
    A_AnimationEffectType_mirror_flipRight      =1104,
    
    // mirror appear effect
    A_AnimationEffectType_mirror_flipInX        =1201,
    A_AnimationEffectType_mirror_flipInY        =1202,
    A_AnimationEffectType_mirror_fadeIn         =1203,
    A_AnimationEffectType_mirror_zoomIn         =1204,
    A_AnimationEffectType_mirror_cardIn         =1205,
    // mirror disappear effect
    A_AnimationEffectType_mirror_flipOutX       =1301,
    A_AnimationEffectType_mirror_flipOutY       =1302,
    A_AnimationEffectType_mirror_fadeOut        =1303,
    A_AnimationEffectType_mirror_zoomOut        =1304,
    A_AnimationEffectType_mirror_cardOut        =1305,
};
