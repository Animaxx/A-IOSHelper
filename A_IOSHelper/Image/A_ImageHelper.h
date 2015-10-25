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
+ (UIImage*) A_ImageQRCode:(NSString*)message Size:(CGSize)size;

#pragma mark - Image cutting
+ (UIImage*) A_CutImage: (UIImage*)image InRect: (CGRect) rect;
+ (UIImage*) A_CutImageByName: (NSString*)imageName InRect:(CGRect)rect;

+ (UIImage *)A_CutImage:(UIImage*)image InCenter:(CGSize)size;

+ (UIImage*) A_Image:(UIImage*)image ScaleToSize:(CGSize)size;
+ (UIImage*) A_ImageByName:(NSString*)name ScaleToSize:(CGSize)size;

+ (UIImage*) A_Image:(UIImage*)image FitToSize:(CGSize)size;
+ (UIImage*) A_ImageByName: (NSString*)name FitToSize:(CGSize)size;

#pragma mark - Alpha
+ (UIImage*) A_Image:(UIImage *)image Alpha:(CGFloat)alpha;
+ (UIImage*) A_ImageByName: (NSString*) name Alpha:(CGFloat)alpha;

#pragma mark - Draw image to circle
+ (UIImage*) A_ImageToCircle:(UIImage*)image;
+ (UIImage*) A_Image:(UIImage*)image ToRoundCorner:(float)radius WithSize:(CGSize)size;

#pragma mark - Rotated image
+ (UIImage*) A_Image:(UIImage*)image RotatedByDegrees:(CGFloat)degrees;
+ (UIImage*) A_ImageByName:(NSString*)name RotatedByDegrees:(CGFloat)degrees;

#pragma mark - Network loading
+ (UIImage*) A_ImageDownload:(NSString*)imageURL;
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL;
+ (UIImage*) A_ImageDownloadAndCache:(NSString*)imageURL DefaultImage:(NSString*)defaultImageName;

#pragma mark - Image operation 
+ (UIImage*) A_MakeUIImageFromCIImage:(CIImage*)ciImage withScale:(CGFloat)scale;
+ (UIImage*) A_CoreImageFilter: (UIImage*)theImage FilterName:(NSString*)filterName FilterParams:(NSDictionary<NSString *,id>*)params;


@end
