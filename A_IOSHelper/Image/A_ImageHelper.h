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

+ (UIImage*) A_ScaleImage:(UIImage*) image ToSize:(CGSize) size;
+ (UIImage*) A_GetImageByNamed:(NSString*) name;
+ (UIImage*) A_ImageFromLayer: (CALayer*) layer;
+ (UIImage*) A_ImageFromColor:(UIColor*) color;

+ (UIImage*) A_ImageFromAllinoneRes: (NSString*) imageName WithRect:(CGRect) rect;
+ (UIImage*) A_GetImageAndScale: (NSString*) name ToSize:(CGSize) size;

+ (UIImage*) A_GetImageNamedAndFit: (NSString*) name ToSize:(CGSize) size;

+ (UIImage*) A_DownloadImage: (NSString*)imageURL;
+ (UIImage*) A_DownloadImageAndCache: (NSString*)imageURL;

+ (UIImage*) A_DownloadImageAndCache: (NSString*)imageURL DefaultImage: (NSString*)defaultImageName;

+ (UIImage*) A_CutImage: (UIImage*)theImage InRect: (CGRect) rect;

@end
