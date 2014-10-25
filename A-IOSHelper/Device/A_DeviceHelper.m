//
//  DeviceHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_DeviceHelper.h"
#import <sys/utsname.h>

@implementation A_DeviceHelper

+ (A_UIDeviceResolution) A_GetDeviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return Device_iPhone1;
    if ([deviceString isEqualToString:@"iPhone1,2"])    return Device_iPhone3g;
    if ([deviceString isEqualToString:@"iPhone2,1"])    return Device_iPhone3gs;
    if ([deviceString isEqualToString:@"iPhone3,1"])    return Device_iPhone4;
    if ([deviceString isEqualToString:@"iPhone3,3"])    return Device_iPhone4;    // Verizon iPhone 4
    if ([deviceString isEqualToString:@"iPhone4,1"])    return Device_iPhone4s;
    if ([deviceString isEqualToString:@"iPhone5,1"])    return Device_iPhone5;    // iPhone 5 (GSM)
    if ([deviceString isEqualToString:@"iPhone5,2"])    return Device_iPhone5;    // iPhone 5 (GSM+CDMA)
    if ([deviceString isEqualToString:@"iPhone5,3"])    return Device_iPhone5c;   // iPhone 5c (GSM)
    if ([deviceString isEqualToString:@"iPhone5,4"])    return Device_iPhone5c;   // iPhone 5c (GSM+CDMA)
    if ([deviceString isEqualToString:@"iPhone6,1"])    return Device_iPhone5s;   // iPhone 5s (GSM)
    if ([deviceString isEqualToString:@"iPhone6,2"])    return Device_iPhone5s;   // iPhone 5s (GSM+CDMA)
    if ([deviceString isEqualToString:@"iPhone7,1"])    return Device_iPhone6plus;  // iPhone 6 Plus
    if ([deviceString isEqualToString:@"iPhone7,2"])    return Device_iPhone6;    // iPhone 6
    if ([deviceString isEqualToString:@"iPod1,1"])      return Device_iPodTouch1; // iPod Touch 1G
    if ([deviceString isEqualToString:@"iPod2,1"])      return Device_iPodTouch2; // iPod Touch 2G
    if ([deviceString isEqualToString:@"iPod3,1"])      return Device_iPodTouch3; // iPod Touch 3G
    if ([deviceString isEqualToString:@"iPod4,1"])      return Device_iPodTouch4; // iPod Touch 4G
    if ([deviceString isEqualToString:@"iPod5,1"])      return Device_iPodTouch5; // iPod Touch 5G
    if ([deviceString isEqualToString:@"iPad1,1"])      return Device_iPad1;      // iPad
    if ([deviceString isEqualToString:@"iPad2,1"])      return Device_iPad2;      // iPad 2 (WiFi)
    if ([deviceString isEqualToString:@"iPad2,2"])      return Device_iPad2;      // iPad 2 (GSM)
    if ([deviceString isEqualToString:@"iPad2,3"])      return Device_iPad2;      // iPad 2 (CDMA)
    if ([deviceString isEqualToString:@"iPad2,4"])      return Device_iPad2;      // iPad 2 (WiFi)
    if ([deviceString isEqualToString:@"iPad2,5"])      return Device_iPadMini;   // iPad Mini (WiFi)
    if ([deviceString isEqualToString:@"iPad2,6"])      return Device_iPadMini;   // iPad Mini (GSM)
    if ([deviceString isEqualToString:@"iPad2,7"])      return Device_iPadMini;   // iPad Mini (GSM+CDMA)
    if ([deviceString isEqualToString:@"iPad3,1"])      return Device_iPad3;      // iPad 3 (WiFi)
    if ([deviceString isEqualToString:@"iPad3,2"])      return Device_iPad3;      // iPad 3 (GSM+CDMA)
    if ([deviceString isEqualToString:@"iPad3,3"])      return Device_iPad3;      // iPad 3 (GSM)
    if ([deviceString isEqualToString:@"iPad3,4"])      return Device_iPad4;      // iPad 4 (WiFi)
    if ([deviceString isEqualToString:@"iPad3,5"])      return Device_iPad4;      // iPad 4 (GSM)
    if ([deviceString isEqualToString:@"iPad3,6"])      return Device_iPad4;      // iPad 4 (GSM+CDMA)
    if ([deviceString isEqualToString:@"iPad4,1"])      return Device_iPadAir;    // iPad Air (WiFi)
    if ([deviceString isEqualToString:@"iPad4,2"])      return Device_iPadAir;    // iPad Air (Cellular)
    if ([deviceString isEqualToString:@"iPad4,4"])      return Device_iPadMini2;  // iPad mini 2G (WiFi)
    if ([deviceString isEqualToString:@"iPad4,5"])      return Device_iPadMini2;  // iPad mini 2G (Cellular)
    if ([deviceString isEqualToString:@"i386"])         return Device_Simulator;
    if ([deviceString isEqualToString:@"x86_64"])       return Device_Simulator;

    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return Device_Unknow;
}


@end
