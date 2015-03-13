//
//  UIView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "UIView+A_Extension.h"
#import "A_Animation.h"
#import "A_DeviceHelper.h"

@implementation UIView (A_Extension)

- (void) A_Animation_FadeIn: (double)duration {
    self.layer.opacity = 0.0f;
    self.layer.hidden = false;
    self.hidden = false;
    
    CABasicAnimation* _animation = [A_Animation A_FadeIn:duration];
    [self.layer addAnimation:_animation forKey:@"animax_fadeIn"];
}
- (void) A_Animation_FadeOut: (double)duration {
    CABasicAnimation* _animation = [A_Animation A_FadeOut:duration];
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            self.layer.hidden = true;
            self.hidden = true;
        }];
        
        [self.layer addAnimation:_animation forKey:@"animax_fadeOut"];
        
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromLeft: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.frame.origin.x * -1, self.layer.position.y);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutLeft"];
}
- (void) A_Animation_MoveOut_FromRight: (double)duration {
    CGPoint _destinationPoint = CGPointMake((CGFloat)[A_DeviceHelper A_DeviceWidth], self.layer.position.y);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutRight"];
}
- (void) A_Animation_MoveOut_FromTop: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, self.layer.frame.origin.y * -1 );
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutTop"];
}
- (void) A_Animation_MoveOut_FromBottom: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutBottom"];
}


@end
