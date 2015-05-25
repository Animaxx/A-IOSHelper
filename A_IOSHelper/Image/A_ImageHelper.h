//
//  A_ImageHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface A_ImageHelper : NSObject

#pragma mark - Generate image
+ (UIImage*) A_ImageByName:(NSString*)name;
+ (UIImage*) A_ImageFromLayer:(CALayer*)layer;
+ (UIImage*) A_ImageFromColor:(UIColor*)color;

#pragma mark - Image cutting
+ (UIImage*) A_Image:(UIImage*)image CutWithRect:(CGRect)rect;
+ (UIImage*) A_ImageByName:(NSString*)imageName CutWithRect:(CGRect)rect;

+ (UIImage*) A_Image:(UIImage*)image ScaleToSize:(CGSize)size;
+ (UIImage*) A_ImageByName:(NSString*)name ScaleToSize:(CGSize)size;

+ (UIImage*) A_Image:(UIImage*)image FitToSize:(CGSize)size;
+ (UIImage*) A_ImageByName: (NSString*)name FitToSize:(CGSize)size;

#pragma mark - Network loading
+ (UIImage*) A_ImageDownload:(NSString*)imageURL;
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL;
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL DefaultImage:(NSString*)defaultImageName;

#pragma mark - Image operation - Blur
+ (UIImage*) A_GaussianBlur:(UIImage*)theImage Radius:(float)radius;
+ (UIImage*) A_GaussianBlur:(UIImage*)theImage;


@end
