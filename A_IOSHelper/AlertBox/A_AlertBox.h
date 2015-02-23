//
//  A_AlertBox.h
//  A_IOSHelper
//
//  Created by Animax on 12/22/14.
//  Copyright (c) 2014 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_AlertBox : NSObject

+ (void)A_SystemAlert:(NSString *) Message AndTitle: (NSString*)Title AndBtnMsg:(NSString*)BtnMessage;
+ (void)A_SystemAlert:(NSString *) Message AndTitle: (NSString*)Title;
+ (void)A_SystemAlert:(NSString *) Message;

@end
