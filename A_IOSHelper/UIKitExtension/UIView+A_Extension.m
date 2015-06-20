//
//  UIView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/13/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+A_Extension.h"
#import "A_DeviceHelper.h"

#define defaultDurationTime 0.5f;

@implementation UIView (A_Extension)

#pragma mark - Animation - Movement
- (void) A_Animation_MoveOut: (A_Animation_DirectionType)directionType Duration:(double)duration {
    CGPoint _destinationPoint;
    switch (directionType) {
        case A_Animation_Direction_Top:
            _destinationPoint = CGPointMake(self.layer.position.x, self.layer.frame.origin.y * -1 );
            break;
        case A_Animation_Direction_Right:
            _destinationPoint = CGPointMake((CGFloat)[A_DeviceHelper A_DeviceWidth] , self.layer.position.y);
            break;
        case A_Animation_Direction_Bottom:
            _destinationPoint = CGPointMake(self.layer.position.x, (CGFloat)[A_DeviceHelper A_DeviceHeight]);
            break;
        case A_Animation_Direction_Left:
            _destinationPoint = CGPointMake(self.layer.frame.size.width * -1, self.layer.position.y);
            break;
        default:
            _destinationPoint = CGPointMake(self.layer.frame.size.width * -1, self.layer.position.y);
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Animation MoveOut> \r\n Unkonw Direction Type \r\n -------- \r\n\r\n");
            return;
    }
    
    CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveOut"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveOut: (A_Animation_DirectionType)directionType Duration:(double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint;
    switch (directionType) {
        case A_Animation_Direction_Top:
            _destinationPoint = CGPointMake(self.layer.position.x, self.layer.frame.origin.y * -1 );
            break;
        case A_Animation_Direction_Right:
            _destinationPoint = CGPointMake((CGFloat)[A_DeviceHelper A_DeviceWidth] , self.layer.position.y);
            break;
        case A_Animation_Direction_Bottom:
            _destinationPoint = CGPointMake(self.layer.position.x, (CGFloat)[A_DeviceHelper A_DeviceHeight]);
            break;
        case A_Animation_Direction_Left:
            _destinationPoint = CGPointMake(self.layer.frame.size.width * -1, self.layer.position.y);
            break;
        default:
            _destinationPoint = CGPointMake(self.layer.frame.size.width * -1, self.layer.position.y);
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Animation MoveOut> \r\n Unkonw Direction Type \r\n -------- \r\n\r\n");
            return;
    }
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveOut"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_CardIn: (A_Animation_DirectionType)directionType Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block{
    [self.layer setHidden:YES];
    [A_Animation A_CardIn:self.layer Direction:directionType Duration:duration WhenCompleted:block];
}
- (void) A_Animation_CardOut: (A_Animation_DirectionType)directionType Duration:(double)duration WhenCompleted:(void (^)(BOOL finished))block{
    [A_Animation A_CardOut:self.layer Direction:directionType Duration:duration WhenCompleted:block];
}

- (void) A_Animation_MoveToCenter: (double)duration {
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:(([A_DeviceHelper A_DeviceWidth] - self.layer.frame.size.width)/2) Y:(([A_DeviceHelper A_DeviceHeight] - self.layer.frame.size.height)/2)];
    
    CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveToCenter"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveToCenter: (double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:(([A_DeviceHelper A_DeviceWidth] - self.layer.frame.size.width)/2) Y:(([A_DeviceHelper A_DeviceHeight] - self.layer.frame.size.height)/2)];
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveToCenter"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration  {
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:x Y:y];
    
    CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveToPosition"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveToPostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = [A_Animation A_MakeLayerPosition:self.layer PositionX:x Y:y];
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveToPosition"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration {
    CGPoint _destinationPoint = CGPointMake(x, y);
    
    CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
    [self.layer addAnimation:_animation forKey:@"animax_moveToAbsolutePosition"];
    self.layer.position = _destinationPoint;
}
- (void) A_Animation_MoveToAbsolutePostionX: (float)x Y:(float)y  Duration:(double)duration WhenCompleted:(void (^)(void))block{
    CGPoint _destinationPoint = CGPointMake(x, y);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CAAnimation* _animation = [A_Animation A_MoveTo:duration OriginalPosition:self.layer.position Destination:_destinationPoint];
        [self.layer addAnimation:_animation forKey:@"animax_moveToAbsolutePosition"];
        self.layer.position = _destinationPoint;
    } [CATransaction commit];
}

- (void) A_Animation_Transition:(A_Animation_SystemTransitionType)transitionType Direction:(A_Animation_DirectionType)directionType Duration:(float)duration {
    CATransition* _transition = [A_Animation A_CreateSystemTransition:transitionType Direction:directionType Duration:duration];
    [self.layer addAnimation:_transition forKey:kCATransition];
}
- (void) A_Animation_Transition:(A_Animation_SystemTransitionType)transitionType Direction:(A_Animation_DirectionType)directionType Duration:(float)duration WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        CATransition* _transition = [A_Animation A_CreateSystemTransition:transitionType Direction:directionType Duration:duration];
        [self.layer addAnimation:_transition forKey:kCATransition];
    } [CATransaction commit];
}

#pragma mark - Animation - Change Shape
- (void) A_Animation_FadeIn: (double)duration {
    CAAnimation* _animation = [A_Animation A_FadeIn:duration];
    [self.layer addAnimation:_animation forKey:@"animax_fadeIn"];
    
    self.layer.opacity = 1.0f;
    self.layer.hidden = false;
    self.hidden = false;
}
- (void) A_Animation_FadeIn: (double)duration WhenCompleted:(void (^)(void))block {
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock: block];
        
        CAAnimation* _animation = [A_Animation A_FadeIn:duration];
        [self.layer addAnimation:_animation forKey:@"animax_fadeIn"];
        
        self.layer.opacity = 1.0f;
        self.layer.hidden = false;
        self.hidden = false;
    } [CATransaction commit];
}
- (void) A_Animation_FadeOut: (double)duration {
    CAAnimation* _animation = [A_Animation A_FadeOut:duration];
    [self.layer addAnimation:_animation forKey:@"animax_fadeOut"];
    
    self.layer.opacity = 0.0f;
}
- (void) A_Animation_FadeOut: (double)duration WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CAAnimation* _animation = [A_Animation A_FadeOut:duration];
        [self.layer addAnimation:_animation forKey:@"animax_fadeOut"];
        self.layer.opacity = 0.0f;
        
    } [CATransaction commit];
}

- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration {
    CAAnimation* _animation = [A_Animation A_ChangeSize:duration OriginalSize:self.layer.bounds To:size];
    
    CGRect newBounds = self.layer.bounds;
    newBounds.size = size;
    self.layer.bounds = newBounds;
    
    [self.layer addAnimation:_animation forKey:@"animax_toSize"];
}
- (void) A_Animation_ToSize: (CGSize)size Duration:(double)duration WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CAAnimation* _animation = [A_Animation A_ChangeSize:duration OriginalSize:self.layer.bounds To:size];
        
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
    CAAnimation* _animation = [A_Animation A_ChangeShapeToBall:duration
                                                     OriginalRadius:self.layer.cornerRadius
                                                                 To:radius];
    
    [self.layer addAnimation:_animation forKey:@"animax_changeRadius"];
    self.layer.cornerRadius = radius;
}
- (void) A_Animation_ChangeCornerRadius: (CGFloat)radius Duration:(double)duration WhenCompleted:(void (^)(void))block{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        
        CAAnimation* _animation = [A_Animation A_ChangeShapeToBall:duration
                                                         OriginalRadius:self.layer.cornerRadius
                                                                     To:radius];
        
        [self.layer addAnimation:_animation forKey:@"animax_changeRadius"];
        self.layer.cornerRadius = radius;
    } [CATransaction commit];
}

#pragma mark - Animation - Execute
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





#pragma mark - Animation Provide
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Duration:(double)duration Start:(id)start End:(id)end FPS:(A_Animation_kFPS)kps {
    
    NSParameterAssert(keypath);
    NSParameterAssert(type);
    NSParameterAssert(end);
    
    if (kps<=0) {
        kps = A_Animation_kFPS_middle;
    }
    if (!start) {
        start = [self.layer valueForKeyPath:keypath];
    }
    if (duration<=0) {
        duration = defaultDurationTime;
    }
    
    CAKeyframeAnimation* keyFrames = [A_Animation A_GenerateKeyframe:keypath Type:type Duration:duration FPS:kps Start:start End:end];
    [self.layer addAnimation:keyFrames forKey:nil];
    [self.layer setValue:end forKeyPath:keypath];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Duration:(double)duration Start:(id)start End:(id)end {
    [self A_AnimationSet:keypath AnimtionType:type Duration:duration Start:start End:end FPS:A_Animation_kFPS_middle];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type Duration:(double)duration End:(id)end {
    [self A_AnimationSet:keypath AnimtionType:type Duration:duration Start:nil End:end FPS:A_Animation_kFPS_middle];
}
- (void) A_AnimationSet:(NSString*)keypath AnimtionType:(A_AnimationType)type End:(id)end {
    [self A_AnimationSet:keypath AnimtionType:type Duration:0 Start:nil End:end FPS:A_Animation_kFPS_middle];
}

- (void) A_AnimationGroupSet {
    // TODO:
}




@end

