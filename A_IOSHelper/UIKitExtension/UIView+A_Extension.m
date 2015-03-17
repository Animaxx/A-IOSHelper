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

#pragma mark - Animation
- (void) A_Animation_FadeIn: (double)duration {
    CABasicAnimation* _animation = [A_Animation A_FadeIn:duration];
    [self.layer addAnimation:_animation forKey:@"animax_fadeIn"];
    
    self.layer.opacity = 1.0f;
    self.layer.hidden = false;
    self.hidden = false;
}
- (void) A_Animation_FadeIn: (double)duration WhenCompleted:(void (^)(void))block {
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock: block];
        
        CABasicAnimation* _animation = [A_Animation A_FadeIn:duration];
        [self.layer addAnimation:_animation forKey:@"animax_fadeIn"];
        
        self.layer.opacity = 1.0f;
        self.layer.hidden = false;
        self.hidden = false;
    } [CATransaction commit];
}

- (void) A_Animation_FadeOut: (double)duration {
    CABasicAnimation* _animation = [A_Animation A_FadeOut:duration];
    [self.layer addAnimation:_animation forKey:@"animax_fadeOut"];
    
    self.layer.opacity = 0.0f;
}
- (void) A_Animation_FadeOut: (double)duration WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_FadeOut:duration];
        [self.layer addAnimation:_animation forKey:@"animax_fadeOut"];
        self.layer.opacity = 0.0f;
        
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromLeft: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.frame.size.width * -1, self.layer.position.y);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutLeft"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveOut_FromLeft: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(self.layer.frame.origin.x * -1, self.layer.position.y);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutLeft"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromRight: (double)duration {
    CGPoint _destinationPoint = CGPointMake((CGFloat)[A_DeviceHelper A_DeviceWidth] , self.layer.position.y);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutRight"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveOut_FromRight: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake((CGFloat)[A_DeviceHelper A_DeviceWidth], self.layer.position.y);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutRight"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromTop: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, self.layer.frame.origin.y * -1 );
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutTop"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveOut_FromTop: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, self.layer.frame.origin.y * -1 );
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutTop"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveOut_FromBottom: (double)duration {
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOutBottom"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveOut_FromBottom: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(self.layer.position.x, (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOutBottom"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveToCenter: (double)duration {
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:(([A_DeviceHelper A_DeviceWidth] - self.layer.frame.size.width)/2) Y:(([A_DeviceHelper A_DeviceHeight] - self.layer.frame.size.height)/2)];
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveToCenter"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveToCenter: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:(([A_DeviceHelper A_DeviceWidth] - self.layer.frame.size.width)/2) Y:(([A_DeviceHelper A_DeviceHeight] - self.layer.frame.size.height)/2)];
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveToCenter"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration  {
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:x Y:y];
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveToPosition"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:x Y:y];
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveToPosition"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration {
    CGPoint _destinationPoint = CGPointMake(x, y);
    
    CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveToAbsolutePosition"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(x, y);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveToAbsolutePosition"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration {
    CABasicAnimation* _animation = [A_Animation A_ChangeSize:duration OriginalSize:self.layer.bounds To:size];
    
    CGRect newBounds = self.layer.bounds;
    newBounds.size = size;
    self.layer.bounds = newBounds;
    
    [self.layer addAnimation:_animation forKey:@"animax_toSize"];
}
- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration WhenCompleted:(void (^)(void))block{
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
    [self A_Animation_ToSize:size Duration:duration];
}
- (void) A_Animation_ToFullScreenSize: (double)duration WhenCompleted:(void (^)(void))block{
    CGSize size = CGSizeMake((CGFloat)[A_DeviceHelper A_DeviceWidth], (CGFloat)[A_DeviceHelper A_DeviceHeight]);
    [self A_Animation_ToSize:size Duration:duration WhenCompleted:block];
}

- (void) A_Animation_ToBall: (double)duration{
    CGFloat _radius = (self.frame.size.width / 2);
    if (self.frame.size.width > self.frame.size.height) {
        _radius = (self.frame.size.height / 2);
    }
    
    [self A_Animation_ChangeCornerRadius:_radius Duration:duration];
}
- (void) A_Animation_ToBall: (double)duration WhenCompleted:(void (^)(void))block{
    CGFloat _radius = (self.frame.size.width / 2);
    if (self.frame.size.width > self.frame.size.height) {
        _radius = (self.frame.size.height / 2);
    }
    
    [self A_Animation_ChangeCornerRadius:_radius Duration:duration WhenCompleted:block];
}

- (void) A_Animation_ChangeCornerRadius: (CGFloat)radius Duration:(double)duration {
    CABasicAnimation* _animation = [A_Animation A_ChangeShapeToBall:duration
                                                     OriginalRadius:self.layer.cornerRadius
                                                                 To:radius];
    
    [self.layer addAnimation:_animation forKey:@"animax_changeRadius"];
    self.layer.cornerRadius = radius;
}
- (void) A_Animation_ChangeCornerRadius: (CGFloat)radius Duration:(double)duration WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CABasicAnimation* _animation = [A_Animation A_ChangeShapeToBall:duration
                                                         OriginalRadius:self.layer.cornerRadius
                                                                     To:radius];
        
        [self.layer addAnimation:_animation forKey:@"animax_changeRadius"];
        self.layer.cornerRadius = radius;
    } [CATransaction commit];
}

- (void) A_Animation_SubmitTransaction: (NSDictionary*)animations WhenCompleted:(void (^)(void))block {
    [A_Animation A_SubmitTransaction:self.layer Animations:animations WhenCompleted:block];
}

#pragma mark - Shape
- (void) A_Shape_ToBall {
    CGFloat _radius = (self.frame.size.width / 2);
    if (self.frame.size.width > self.frame.size.height) {
        _radius = (self.frame.size.height / 2);
    }
    
    self.layer.cornerRadius = _radius;
}




@end

