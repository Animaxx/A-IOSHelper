//
//  UIImage+A_Extension.h
//  A_IOSHelper
//
//  Created by Animax on 3/18/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (A_Extension)

#pragma mark - Generate image
+ (UIImage*) A_ImageByName:(NSString*)name;
+ (UIImage*) A_ImageFromLayer:(CALayer*)layer;
+ (UIImage*) A_ImageFromColor:(UIColor*)color;

#pragma mark - Network loading
+ (UIImage*) A_ImageDownload:(NSString*)imageURL;
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL;
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL DefaultImage:(NSString*)defaultImageName;

#pragma mark - Image cutting
- (UIImage*) A_ImageCutWithRect:(CGRect)rect;
+ (UIImage*) A_ImageByName:(NSString*)imageName CutWithRect:(CGRect)rect;

- (UIImage*) A_ImageScaleToSize:(CGSize)size;
+ (UIImage*) A_ImageByName:(NSString*)name ScaleToSize:(CGSize)size;

- (UIImage*) A_ImageFitToSize:(CGSize)size;
+ (UIImage*) A_ImageByName: (NSString*)name FitToSize:(CGSize)size;

#pragma mark - Image operation - Blur
- (UIImage*) A_GaussianBlurWithRadius:(float)radius;
- (UIImage*) A_GaussianBlur;

@end
