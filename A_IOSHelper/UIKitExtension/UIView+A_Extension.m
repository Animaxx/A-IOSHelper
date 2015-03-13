//
//  UIView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
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
- (void) A_Animation_FadeIn: (double)duration WhenCompleted:(void (^)(void))block {
    self.layer.opacity = 0.0f;
    self.layer.hidden = false;
    self.hidden = false;
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock: block];
        
        CABasicAnimation* _animation = [A_Animation A_FadeIn:duration];
        [self.layer addAnimation:_animation forKey:@"animax_fadeIn"];
    } [CATransaction commit];
}

- (void) A_Animation_FadeOut: (double)duration {
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            self.layer.hidden = true;
            self.hidden = true;
        }];
        
        CABasicAnimation* _animation = [A_Animation A_FadeOut:duration];
        [self.layer addAnimation:_animation forKey:@"animax_fadeOut"];
        
    } [CATransaction commit];
}
- (void) A_Animation_FadeOut: (double)duration WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_FadeOut:duration];
        [self.layer addAnimation:_animation forKey:@"animax_fadeOut"];
        
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromLeft: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.frame.origin.x * -1, self.layer.position.y);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutLeft"];
}
- (void) A_Animation_MoveOut_FromLeft: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(self.layer.frame.origin.x * -1, self.layer.position.y);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutLeft"];
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromRight: (double)duration {
    CGPoint _destinationPoint = CGPointMake((CGFloat)[A_DeviceHelper A_DeviceWidth], self.layer.position.y);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutRight"];
}
- (void) A_Animation_MoveOut_FromRight: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake((CGFloat)[A_DeviceHelper A_DeviceWidth], self.layer.position.y);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutRight"];
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromTop: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, self.layer.frame.origin.y * -1 );
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutTop"];
}
- (void) A_Animation_MoveOut_FromTop: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, self.layer.frame.origin.y * -1 );
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutTop"];
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromBottom: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutBottom"];
}
- (void) A_Animation_MoveOut_FromBottom: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutBottom"];
    } [CATransaction commit];
}

- (void) A_Animation_MoveToCenter: (double)duration {
    CGPoint _destinationPoint = CGPointMake(((CGFloat)[A_DeviceHelper A_DeviceWidth]/2 - self.layer.frame.origin.x/2), ((CGFloat)[A_DeviceHelper A_DeviceHeight]/2 - self.layer.frame.origin.y/2));
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveToCenter"];
}
- (void) A_Animation_MoveToCenter: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(((CGFloat)[A_DeviceHelper A_DeviceWidth]/2 - self.layer.frame.origin.x/2), ((CGFloat)[A_DeviceHelper A_DeviceHeight]/2 - self.layer.frame.origin.y/2));
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveToCenter"];
    } [CATransaction commit];
}

- (void) A_Animation_ToSize: (double)duration Size: (CGSize)size {
    CABasicAnimation* _animation = [A_Animation A_ChangeSize:duration OriginalSize:self.layer.bounds To:size];
    
    CGRect newBounds = self.layer.bounds;
    newBounds.size = size;
    self.layer.bounds = newBounds;
    
    [self.layer addAnimation:_animation forKey:@"animax_toSize"];
}
- (void) A_Animation_ToSize: (double)duration Size: (CGSize)size WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_ChangeSize:duration OriginalSize:self.layer.bounds To:size];
        
        CGRect newBounds = self.layer.bounds;
        newBounds.size = size;
        self.layer.bounds = newBounds;
        
        [self.layer addAnimation:_animation forKey:@"animax_toSize"];
    } [CATransaction commit];
}

- (void) A_Animation_ToFullScreenSize: (double)duration{
    CGSize size = CGSizeMake((CGFloat)[A_DeviceHelper A_DeviceWidth], (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    [self A_Animation_ToSize:duration Size:size];
}
- (void) A_Animation_ToFullScreenSize: (double)duration WhenCompleted:(void (^)(void))block{
    CGSize size = CGSizeMake((CGFloat)[A_DeviceHelper A_DeviceWidth], (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    [self A_Animation_ToSize:duration Size:size WhenCompleted:block];
}

@end

