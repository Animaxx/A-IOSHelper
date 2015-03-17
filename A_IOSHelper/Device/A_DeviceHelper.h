//
//  DeviceHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_DeviceHelper : NSObject

enum {
    Device_Unknow               = 0,
    Device_Simulator            = 1,
    
    Device_iPhone1              = 2,
    Device_iPhone3g             = 3,
    Device_iPhone3gs            = 4,
    Device_iPhone4              = 5,
    Device_iPhone4s             = 6,
    Device_iPhone5              = 7,
    Device_iPhone5s             = 8,
    Device_iPhone5c             = 9,
    Device_iPhone6              = 10,
    Device_iPhone6plus          = 11,
    
    Device_iPodTouch1           = 51,
    Device_iPodTouch2           = 52,
    Device_iPodTouch3           = 53,
    Device_iPodTouch4           = 54,
    Device_iPodTouch5           = 55,
    
    Device_iPad1                = 101,
    Device_iPad2                = 102,
    Device_iPad3                = 103,
    Device_iPad4                = 104,
    Device_iPadAir              = 105,
    Device_iPadAir2             = 106,
    
    Device_iPadMini             = 201,
    Device_iPadMini2            = 202,
    Device_iPadMini3            = 203,
    
}; typedef NSUInteger A_UIDeviceResolution;

+ (A_UIDeviceResolution) A_DeviceVersion;

+ (float)A_DeviceWidth;
+ (float)A_DeviceHeight;

+ (float)A_DeviceExactWidth;
+ (float)A_DeviceExactHeight;

+ (BOOL) A_CheckCameraAvailable;
+ (BOOL) A_CheckCideoCameraAvailable;
+ (BOOL) A_CheckFrontCameraAvailable;
+ (BOOL) A_CheckCanSendSMS;
+ (BOOL) A_CheckCanCall;

@end
