//
//  UIAlertView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 5/2/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (A_Extension)

+ (void)A_DisplyAlert:(NSString *)Message AndTitle:(NSString*)Title CancelButton:(NSString*)BtnMessage;
+ (void)A_DisplyAlert:(NSString *)Message
             AndTitle:(NSString *)Title
      CompletionBlock:(void (^)(UIAlertView *alertView, NSInteger buttonIndex, id argument)) block
        CompletionObj:(id)obj
         CancelButton:(NSString *)cancelButtonTitle
        ConfirmButton:(NSString *)confirmButtonTitle;

- (void)A_SetCompletionBlock:(void (^)(UIAlertView *alertView, NSInteger buttonIndex, id argument)) block WithObj:(id)arg;

@end
