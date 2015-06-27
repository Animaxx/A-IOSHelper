//
//  A_AnimationKeyframeProvider.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/26/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "A_AnimationEnumeration.h"

@interface A_AnimationKeyframeProvider : NSObject

+(CAKeyframeAnimation*)A_GenerateKeyframe:(NSString*)keypath Type:(A_AnimationType)type Duration:(double)duration FPS:(A_AnimationFPS)kpfs Start:(id)start End:(id)end;

@end
