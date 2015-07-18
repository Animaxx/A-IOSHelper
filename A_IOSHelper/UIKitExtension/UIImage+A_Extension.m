//
//  UIImage+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/18/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "UIImage+A_Extension.h"
#import "A_ImageHelper.h"

@implementation UIImage (A_Extension)

#pragma mark - Generate image
+ (UIImage*) A_ImageByName:(NSString*)name {
    return [A_ImageHelper A_ImageByName:name];
}
+ (UIImage*) A_ImageFromLayer:(CALayer*)layer {
    return [A_ImageHelper A_ImageFromLayer:layer];
}
+ (UIImage*) A_ImageFromColor:(UIColor*)color {
    return [A_ImageHelper A_ImageFromColor:color];
}

#pragma mark - Image cutting
- (UIImage*) A_ImageCutWithRect:(CGRect)rect {
    UIImage *_result = [A_ImageHelper A_Image:self CutWithRect:rect];
    return _result;
}
+ (UIImage*) A_ImageByName:(NSString*)imageName CutWithRect:(CGRect)rect {
    return [A_ImageHelper A_ImageByName:imageName CutWithRect:rect];
}

- (UIImage*) A_ImageScaleToSize:(CGSize)size {
    return [A_ImageHelper A_Image:self ScaleToSize:size];
}
+ (UIImage*) A_ImageByName:(NSString*)name ScaleToSize:(CGSize)size {
    return [A_ImageHelper A_ImageByName:name ScaleToSize:size];
}

- (UIImage*) A_ImageFitToSize:(CGSize)size {
    return [A_ImageHelper A_Image:self FitToSize:size];
}
+ (UIImage*) A_ImageByName: (NSString*)name FitToSize:(CGSize)size{
    return [A_ImageHelper A_ImageByName:name FitToSize:size];
}

#pragma mark - Alpha
- (UIImage*) A_ImageAlpha:(CGFloat)alpha {
    return [A_ImageHelper A_Image:self Alpha:alpha];
}
+ (UIImage*) A_ImageByName: (NSString*) name Alpha:(CGFloat)alpha {
    return [A_ImageHelper A_ImageByName:name Alpha:alpha];
}

#pragma mark - Rotated image
- (UIImage*) A_ImageRotatedByDegrees:(CGFloat)degrees {
    return [A_ImageHelper A_Image:self RotatedByDegrees:degrees];
}
+ (UIImage*) A_ImageByName:(NSString*)name RotatedByDegrees:(CGFloat)degrees {
    return [A_ImageHelper A_ImageByName:name RotatedByDegrees:degrees];
}

#pragma mark - Make to circle
- (UIImage*) A_ImageToCircle {
    return [A_ImageHelper A_ImageToCircle:self];
}
- (UIImage*) A_ImageToRoundCorner:(float)radius {
    return [A_ImageHelper A_Image:self ToRoundCorner:radius WithSize:self.size];
}
- (UIImage*) A_ImageToRoundCorner:(float)radius WithSize:(CGSize)size{
    return [A_ImageHelper A_Image:self ToRoundCorner:radius WithSize:size];
}

+ (UIImage*) A_ImageToCircleByName: (NSString*)name{
    UIImage *image = [UIImage imageNamed:name];
    return [image A_ImageToCircle];
}
+ (UIImage*) A_ImageByName: (NSString*)name ToRoundCorner:(float)radius{
    UIImage *image = [UIImage imageNamed:name];
    return [image A_ImageToRoundCorner:radius];
}
+ (UIImage*) A_ImageByName: (NSString*)name ToRoundCorner:(float)radius WithSize:(CGSize)size{
    UIImage *image = [UIImage imageNamed:name];
    return [image A_ImageToRoundCorner:radius WithSize:size];
}


#pragma mark - Network loading
+ (UIImage*) A_ImageDownload:(NSString*)imageURL {
    return [A_ImageHelper A_ImageDownload:imageURL];
}
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL {
    return [A_ImageHelper A_ImageDownloadAndCache:imageURL];
}
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL DefaultImage:(NSString*)defaultImageName {
    return [A_ImageHelper A_ImageDownloadAndCache:imageURL DefaultImage:defaultImageName];
}

#pragma mark - QR code
+ (UIImage*) A_ImageQRCode:(NSString*)message Size:(CGSize)size {
    return [A_ImageHelper A_ImageQRCode:message Size:size];
}

#pragma mark - Image operation - Blur
- (UIImage*) A_GaussianBlurWithRadius:(float)radius {
    return [A_ImageHelper A_GaussianBlur:self Radius:radius];
}
- (UIImage*) A_GaussianBlur {
    return [A_ImageHelper A_GaussianBlur:self];
}



@end


