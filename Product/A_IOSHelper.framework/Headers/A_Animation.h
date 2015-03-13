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

+ (CABasicAnimation*) FadeIn: (CALayer*) layer Duration:(double)duration;
+ (CABasicAnimation*) FadeOut: (CALayer*) layer Duration:(double)duration;


@end
