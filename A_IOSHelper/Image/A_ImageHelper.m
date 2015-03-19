//
//  A_ImageHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_ImageHelper.h"

@implementation A_ImageHelper

+ (UIImage*) A_ScaleImage:(UIImage*) image ToSize:(CGSize) size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+ (UIImage*) A_GetImageByNamed:(NSString*) name{
    if (name != nil && name.length > 0) {
        NSString* path= [[NSBundle mainBundle] pathForResource:name ofType:@""];
        if (path != nil && path.length > 0) {
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            return image;
        }
    }
    return nil;
}

+ (UIImage*) A_ImageFromLayer: (CALayer*) layer{
    UIGraphicsBeginImageContext(layer.frame.size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage*) A_ImageFromColor:(UIColor*) color {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    label.backgroundColor = color;
    
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage*) A_ImageFromAllinoneRes: (NSString*) imageName WithRect:(CGRect) rect {
    UIImage* image = [UIImage imageNamed:imageName];
    
    if (image != nil) {
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        image = [UIImage imageWithCGImage: imageRef];
        CGImageRelease(imageRef);
    }
    return image;
}

+ (UIImage*) A_GetImageAndScale: (NSString*) name ToSize:(CGSize) size {
    UIImage* image = [UIImage imageNamed:name];
    if (image) {
        image = [self A_ScaleImage:image ToSize:size];
    }
    return image;
}

+ (UIImage*) A_GetImageNamedAndFit: (NSString*) name ToSize:(CGSize) size{
    UIImage* image = [UIImage imageNamed:name];
    
    if (image && image.size.width>0 && image.size.height>0) {
        float imgFactor = image.size.width / image.size.height;
        float dstFactor = size.width / size.height;
        
        float width = 0;
        float height = 0;
        if (imgFactor > dstFactor) {
            width = size.width;
            height = width/imgFactor;
        }
        else {
            height = size.height;
            width = height*imgFactor;
        }
        image = [self A_ScaleImage:image ToSize:CGSizeMake(width, height)];
    }
    return image;
}

+ (UIImage*) A_DownloadImage: (NSString*)imageURL {
    NSData* _imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    if (_imgData && _imgData.length <= 0){
        _imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    }
    if (_imgData){
        UIImage* _retuanIamge = [[UIImage alloc] initWithData:_imgData];
        if (_retuanIamge) {
            return _retuanIamge;
        }
    }
    
    return nil;
}

+ (UIImage*) A_DownloadImageAndCache: (NSString*)imageURL  {
    if (!imageURL)
        return nil;
    
    NSString *aPathLocal=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[imageURL lastPathComponent]];
    UIImage* _retuanIamge =[[UIImage alloc]initWithContentsOfFile:aPathLocal];
    
    if (_retuanIamge) {
        return _retuanIamge;
    }
    
    NSData* _imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    if (_imgData && _imgData.length <= 0){
        _imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    }
    if (_imgData){
        
        // Save Image
        NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[imageURL lastPathComponent]];
        [_imgData writeToFile:aPath atomically:YES];
        
        _retuanIamge = [[UIImage alloc] initWithData:_imgData];
        if (_retuanIamge) {
            return _retuanIamge;
        }
    }
    return nil;
}

+ (UIImage*) A_DownloadImageAndCache: (NSString*)imageURL DefaultImage: (NSString*)defaultImageName {
    UIImage* _result = [self A_DownloadImageAndCache:imageURL];
    if(!_result) {
        _result = [UIImage imageNamed:defaultImageName];
    }
    return _result;
}

+ (UIImage*) A_CutImage: (UIImage*)theImage InRect: (CGRect) rect {
    CGImageRef imageRef =CGImageCreateWithImageInRect(theImage.CGImage, rect);
    UIImage* _image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return _image;
}


/* https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIGaussianBlur */
+ (UIImage*) A_GaussianBlur: (UIImage*)theImage Radius:(float)radius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [[CIImage alloc] initWithImage:theImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}
+ (UIImage*) A_GaussianBlur: (UIImage*)theImage {
    return [self A_GaussianBlur:theImage Radius:10.0f];
}




@end
