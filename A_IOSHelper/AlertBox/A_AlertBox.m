//
//  A_AlertBox.m
//  A_IOSHelper
//
//  Created by Animax on 12/22/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import "A_AlertBox.h"
#import <UIKit/UIKit.h>

@implementation A_AlertBox

+ (void)A_SystemAlert:(NSString *) Message AndTitle: (NSString*)Title CancelButton:(NSString*)BtnMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title
                                                    message:Message
                                                   delegate:nil
                                          cancelButtonTitle:BtnMessage
                                          otherButtonTitles:nil];
    [alert show];
}
//+ (void)A_SystemAlert:(NSString *) Message AndTitle: (NSString*)Title {
//    [self A_SystemAlert:Message AndTitle:Title AndBtnMsg:@"OK"];
//}
//+ (void)A_SystemAlert:(NSString *) Message {
//    [self A_SystemAlert:Message AndTitle:@""];
//}

@end
