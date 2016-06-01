//
//  A_ImageHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_ImageHelper.h"

@implementation A_ImageHelper


+ (UIImage*) A_ImageByName:(NSString*) name{
    if (name != nil && name.length > 0) {
        NSString *path= [[NSBundle mainBundle] pathForResource:name ofType:@""];
        if (path != nil && path.length > 0) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            return image;
        }
    }
    return nil;
}
+ (UIImage*) A_ImageFromLayer:(CALayer*) layer{
    UIGraphicsBeginImageContext(layer.frame.size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}
+ (UIImage*) A_ImageFromColor:(UIColor*) color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    label.backgroundColor = color;
    
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage*) A_ImageQRCode:(NSString*)message {
    @autoreleasepool {
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setDefaults];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKey:@"inputMessage"];
        
        CIImage *outputImage = [filter outputImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
        
        return image;
    }
}
+ (UIImage*) A_ImageQRCode:(NSString*)message Size:(CGSize)size {
    UIImage *image = [A_ImageHelper A_ImageQRCode:message];
    UIImage *result = [A_ImageHelper A_Image:image FitToSize:size];
    return result;
}

+ (UIImage*) A_CutImage: (UIImage*)image InRect: (CGRect) rect {
    if (image != nil) {
        CGRect fromRect = CGRectMake(rect.origin.x * image.scale,
                                     rect.origin.y * image.scale,
                                     rect.size.width * image.scale,
                                     rect.size.height * image.scale);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, fromRect);
        image = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
    }
    return image;
}
+ (UIImage*) A_CutImageByName: (NSString*)imageName InRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:imageName];
    return [A_ImageHelper A_CutImage:image InRect:rect];
}

+ (UIImage *)A_CutImage:(UIImage*)image InCenter:(CGSize)size {
    CGRect rect = CGRectMake(ceil((image.size.width - size.width) / 2), ceil((image.size.height - size.height) / 2), size.width, size.height);
    return [A_ImageHelper A_CutImage:image InRect:rect];
}

+ (UIImage*) A_Image:(UIImage*)image ScaleToSize:(CGSize) size {
    if (image != nil) {
        CGSize _size = CGSizeMake(size.width * image.scale, size.height * image.scale);
        
        UIGraphicsBeginImageContext(_size);
        [image drawInRect:CGRectMake(0, 0, _size.width, _size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}
+ (UIImage*) A_ImageByName: (NSString*) name ScaleToSize:(CGSize) size {
    UIImage *image = [UIImage imageNamed:name];
    if (image) {
        image = [self A_Image:image ScaleToSize:size];
    }
    return image;
}

+ (UIImage*) A_Image:(UIImage*)image FitToSize:(CGSize) size {
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
        image = [self A_Image:image ScaleToSize:CGSizeMake(width, height)];
    }
    return image;
}
+ (UIImage*) A_ImageByName: (NSString*) name FitToSize:(CGSize) size{
    UIImage *image = [UIImage imageNamed:name];
    return [A_ImageHelper A_Image:image FitToSize:size];
}

+ (UIImage*) A_Image:(UIImage *)image Alpha:(CGFloat)alpha {
    if (!image) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (UIImage*) A_ImageByName: (NSString*) name Alpha:(CGFloat)alpha {
    UIImage *image = [UIImage imageNamed:name];
    return [A_ImageHelper A_Image:image Alpha:(CGFloat)alpha];
}

+ (UIImage*) A_Image:(UIImage*)image RotatedByDegrees:(CGFloat)degrees {
    if (!image) return image;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat angleInRadians = degrees * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, YES);
    CGContextSetShouldAntialias(bmContext, YES);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(rotatedRect.size.width/2),
                          +(rotatedRect.size.height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(rotatedRect.size.width/2),
                          -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             rotatedRect.size.width,
                                             rotatedRect.size.height),
                       imgRef);
    
    
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    
    UIImage *outImage = [UIImage imageWithCGImage:rotatedImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(rotatedImage);
    
    return outImage;
}
+ (UIImage*) A_ImageByName:(NSString*)name RotatedByDegrees:(CGFloat)degrees {
    UIImage *image = [UIImage imageNamed:name];
    return [A_ImageHelper A_Image:image RotatedByDegrees:(CGFloat)degrees];
}

+ (UIImage*) A_ImageToCircle:(UIImage*)image {
    CGSize _size = image.size;
    CGFloat _minValue = fminf(_size.width, _size.height);
    
    return [self A_Image:image ToRoundCorner:_minValue/2.0f WithSize:CGSizeMake(_minValue, _minValue)];
}
+ (UIImage*) A_Image:(UIImage*)image ToRoundCorner:(float)radius WithSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contextRef);
    
    if (radius == 0 ) {
        CGContextAddRect(contextRef, rect);
    } else {
        float fw, fh;
        CGContextSaveGState(contextRef);
        CGContextTranslateCTM(contextRef, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(contextRef, radius, radius);
        fw = CGRectGetWidth(rect) / radius;
        fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(contextRef, fw, fh/2);  // Start at lower right corner
        CGContextAddArcToPoint(contextRef, fw, fh, fw/2, fh, 1);  // Top right corner
        CGContextAddArcToPoint(contextRef, 0, fh, 0, fh/2, 1); // Top left corner
        CGContextAddArcToPoint(contextRef, 0, 0, fw/2, 0, 1); // Lower left corner
        CGContextAddArcToPoint(contextRef, fw, 0, fw, fh/2, 1); // Back to lower right
        
        CGContextClosePath(contextRef);
        CGContextRestoreGState(contextRef);
    }
    
    CGContextClosePath(contextRef);
    CGContextClip(contextRef);
    
    [image drawInRect:rect];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

+ (void) A_SaveImage:(UIImage *)image To:(NSString *)key {
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
    
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:aPath atomically:YES];
}
+ (UIImage *) A_GetImageFrom:(NSString *)key {
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),key];
    UIImage *returnIamge =[[UIImage alloc]initWithContentsOfFile:aPath];
    return returnIamge;
}
+ (UIImage *) A_GetImageFromURL:(NSString *)url {
    NSString *filename = [url stringByReplacingOccurrencesOfString:@"https" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"http" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@":" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    filename = [filename stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    
    return [self A_GetImageFrom:filename];
}

+ (UIImage*) A_ImageDownload: (NSString*)imageURL {
    NSData *_imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    if (_imgData && _imgData.length <= 0){
        _imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    }
    if (_imgData){
        UIImage *_returnIamge = [[UIImage alloc] initWithData:_imgData];
        if (_returnIamge) {
            return _returnIamge;
        }
    }
    
    return nil;
}
+ (UIImage*) A_ImageDownloadAndCache: (NSString*)imageURL  {
    if (!imageURL)
        return nil;
    
    NSString *filename = [imageURL stringByReplacingOccurrencesOfString:@"https" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"http" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@":" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    filename = [filename stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    
    NSString *aPathLocal=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),filename];
    UIImage *_returnIamge =[[UIImage alloc]initWithContentsOfFile:aPathLocal];
    
    if (_returnIamge) {
        return _returnIamge;
    }
    
    NSData *_imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    if (_imgData && _imgData.length <= 0){
        _imgData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageURL]];
    }
    if (_imgData){
        // Save Image
        NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),filename];
        [_imgData writeToFile:aPath atomically:YES];
        
        _returnIamge = [[UIImage alloc] initWithData:_imgData];
        if (_returnIamge) {
            return _returnIamge;
        }
    }
    return nil;
}
+ (UIImage*) A_ImageDownloadAndCache: (NSString*)imageURL DefaultImage: (NSString*)defaultImageName {
    UIImage *_result = [self A_ImageDownloadAndCache:imageURL];
    if(!_result) {
        _result = [UIImage imageNamed:defaultImageName];
    }
    return _result;
}

+ (UIImage*) A_MakeUIImageFromCIImage:(CIImage*)ciImage withScale:(CGFloat)scale {
    CIContext *cicontext = [CIContext contextWithOptions:nil];
    UIImage * returnImage;
    
    CGImageRef processedCGImage = [cicontext createCGImage:ciImage fromRect:[ciImage extent]];
    
    returnImage = [UIImage imageWithCGImage:processedCGImage scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(processedCGImage);
    
    return returnImage;
}

/* https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html */
+ (UIImage*) A_CoreImageFilter: (UIImage*)theImage FilterName:(NSString*)filterName FilterParams:(NSDictionary<NSString *,id>*)params {
    @autoreleasepool {
        CIImage *image = [[CIImage alloc] initWithImage:theImage];
        CIFilter *filter = [CIFilter filterWithName:filterName];
        [filter setValue:image forKey:kCIInputImageKey];
        for (NSString *key in params) {
            [filter setValue:params[key] forKey:key];
        }
        
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        UIImage *blurImage = [A_ImageHelper A_MakeUIImageFromCIImage:result withScale:theImage.scale];
        
        return blurImage;
    }
}

@end
