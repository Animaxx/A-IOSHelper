//
//  UIImageView+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 5/26/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (A_Extension)

- (void)A_LoadFromUrl:(NSString*)url;
- (void)A_LoadFromUrl:(NSString*)url WithDeaultImage:(NSString*)deaultImage;
- (void)A_LoadFromUrl:(NSString*)url WithDeaultImage:(NSString*)deaultImage AndLoadingImage:(NSString*)loadingImage;

@end
