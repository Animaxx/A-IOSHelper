//
//  A_Animation.h
//  A_IOSHelper
//
//  Created by Animax on 12/10/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "A_AnimationEnumeration.h"

@interface A_Animation : NSObject

#pragma mark - Keyframe animation
+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_AnimationFPS)kpfs Start:(id)start End:(id)end;
+(CAAnimationGroup*)A_GenerateEffect:(A_AnimationEffectType)type Duration:(double)duration;

+(BOOL)A_CheckIfMirrorEffect:(A_AnimationEffectType)type;
+(BOOL)A_CheckIfDisappearingEffect:(A_AnimationEffectType)type;
+(A_AnimationEffectType)A_ConvertMirrorEffect:(A_AnimationEffectType)type;

@end


