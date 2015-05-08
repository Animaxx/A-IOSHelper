//
//  UIAlertView+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 5/2/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <objc/runtime.h>
#import "UIAlertView+A_Extension.h"
#import "A_BlockWrapper.h"

@interface A_AlertViewDelegate : NSObject <UIAlertViewDelegate>

@property (readwrite, nonatomic) void* block;
@property (strong, nonatomic) id argument;

- (id)initWithBlock:(void*)block andObj:(id)obj;

@end

@implementation A_AlertViewDelegate

- (id)initWithBlock:(void*)block andObj:(id)obj{
    self = [super init];
    if (self){
        self.block = block;
        self.argument = obj;
    }
    return self;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block){
        ((void (^)(UIAlertView * alertView, NSInteger buttonIndex, id argument))self.block)(alertView, buttonIndex, nil);
        self.block = nil;
    }
}

@end

@implementation UIAlertView(A_Extension)

+ (void)A_DisplyAlert:(NSString *) Message AndTitle: (NSString*)Title CancelButton:(NSString*)BtnMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title
                                                    message:Message
                                                   delegate:nil
                                          cancelButtonTitle:BtnMessage
                                          otherButtonTitles:nil];
    [alert show];
}
+ (void)A_DisplyAlert:(NSString *)Message
             AndTitle:(NSString*)Title
      CompletionBlock:(void (^)(UIAlertView * alertView, NSInteger buttonIndex, id argument)) block
        CompletionObj:(id)obj
         CancelButton:(NSString*)cancelButtonTitle
         ConfirmButton:(NSString*)confirmButtonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title
                                                    message:Message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:confirmButtonTitle,nil];
    [alert A_SetCompletionBlock:block WithObj:obj];
    [alert show];
}
//
//- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

A_AlertViewDelegate* _alertDelegate;
- (void)A_SetCompletionBlock:(void (^)(UIAlertView * alertView, NSInteger buttonIndex, id argument)) block WithObj:(id)arg {
    _alertDelegate = nil;
    if (block) {
        _alertDelegate = [[A_AlertViewDelegate alloc] initWithBlock:(__bridge void *)(block) andObj:arg];
        objc_setAssociatedObject(self, "AlertViewDelegate", _alertDelegate, OBJC_ASSOCIATION_RETAIN);
    }
}


@end
