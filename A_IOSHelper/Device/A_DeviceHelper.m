//
//  DeviceHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_DeviceHelper.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

#import <MobileCoreServices/MobileCoreServices.h>

@implementation A_DeviceHelper

+ (A_UIDeviceResolution) A_DeviceVersion {
    /* List in http:theiphonewiki.com/wiki/Models */
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return Device_iPhone1;
    if ([deviceString isEqualToString:@"iPhone1,2"])    return Device_iPhone3g;
    if ([deviceString isEqualToString:@"iPhone2,1"])    return Device_iPhone3gs;
    if ([deviceString isEqualToString:@"iPhone3,1"])    return Device_iPhone4;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return Device_iPhone4;
    if ([deviceString isEqualToString:@"iPhone3,3"])    return Device_iPhone4;
    if ([deviceString isEqualToString:@"iPhone4,1"])    return Device_iPhone4s;
    if ([deviceString isEqualToString:@"iPhone5,1"])    return Device_iPhone5;    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return Device_iPhone5;    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return Device_iPhone5c;   
    if ([deviceString isEqualToString:@"iPhone5,4"])    return Device_iPhone5c;   
    if ([deviceString isEqualToString:@"iPhone6,1"])    return Device_iPhone5s;   
    if ([deviceString isEqualToString:@"iPhone6,2"])    return Device_iPhone5s;   
    if ([deviceString isEqualToString:@"iPhone7,1"])    return Device_iPhone6plus;
    if ([deviceString isEqualToString:@"iPhone7,2"])    return Device_iPhone6;    
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return Device_iPodTouch1; 
    if ([deviceString isEqualToString:@"iPod2,1"])      return Device_iPodTouch2; 
    if ([deviceString isEqualToString:@"iPod3,1"])      return Device_iPodTouch3; 
    if ([deviceString isEqualToString:@"iPod4,1"])      return Device_iPodTouch4; 
    if ([deviceString isEqualToString:@"iPod5,1"])      return Device_iPodTouch5;
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return Device_iPad1;
    if ([deviceString isEqualToString:@"iPad2,1"])      return Device_iPad2;      
    if ([deviceString isEqualToString:@"iPad2,2"])      return Device_iPad2;      
    if ([deviceString isEqualToString:@"iPad2,3"])      return Device_iPad2;      
    if ([deviceString isEqualToString:@"iPad2,4"])      return Device_iPad2;      
    if ([deviceString isEqualToString:@"iPad3,1"])      return Device_iPad3;      
    if ([deviceString isEqualToString:@"iPad3,2"])      return Device_iPad3;      
    if ([deviceString isEqualToString:@"iPad3,3"])      return Device_iPad3;      
    if ([deviceString isEqualToString:@"iPad3,4"])      return Device_iPad4;      
    if ([deviceString isEqualToString:@"iPad3,5"])      return Device_iPad4;      
    if ([deviceString isEqualToString:@"iPad3,6"])      return Device_iPad4;      
    if ([deviceString isEqualToString:@"iPad4,1"])      return Device_iPadAir;
    if ([deviceString isEqualToString:@"iPad4,2"])      return Device_iPadAir;
    if ([deviceString isEqualToString:@"iPad4,3"])      return Device_iPadAir;
    if ([deviceString isEqualToString:@"iPad5,3"])      return Device_iPadAir2;
    if ([deviceString isEqualToString:@"iPad5,4"])      return Device_iPadAir2;
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return Device_iPadMini;   
    if ([deviceString isEqualToString:@"iPad2,6"])      return Device_iPadMini;   
    if ([deviceString isEqualToString:@"iPad2,7"])      return Device_iPadMini;   
    if ([deviceString isEqualToString:@"iPad4,4"])      return Device_iPadMini2;  
    if ([deviceString isEqualToString:@"iPad4,5"])      return Device_iPadMini2;
    if ([deviceString isEqualToString:@"iPad4,6"])      return Device_iPadMini2;
    if ([deviceString isEqualToString:@"iPad4,7"])      return Device_iPadMini3;
    if ([deviceString isEqualToString:@"iPad4,8"])      return Device_iPadMini3;
    if ([deviceString isEqualToString:@"iPad4,9"])      return Device_iPadMini3;
    
    if ([deviceString isEqualToString:@"i386"])         return Device_Simulator;
    if ([deviceString isEqualToString:@"x86_64"])       return Device_Simulator;
    
    NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Unkonw device type> \r\n %@", deviceString);
    return Device_Unknow;
}
+ (float)A_DeviceWidth {
    return (NSInteger)[[UIScreen mainScreen] bounds].size.width;
}
+ (float)A_DeviceHeight {
    return (NSInteger)[[UIScreen mainScreen] bounds].size.height;
}

+ (float)A_DeviceExactWidth {
    return (NSInteger)[[UIScreen mainScreen] currentMode].size.width;
}
+ (float)A_DeviceExactHeight {
    return (NSInteger)[[UIScreen mainScreen] currentMode].size.height;
}

+ (BOOL) A_CheckCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
+ (BOOL) A_CheckCideoCameraAvailable {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    if (![sourceTypes containsObject:(NSString *)kUTTypeMovie ]){
        
        return NO;
    }
    
    return YES;
}
+ (BOOL) A_CheckFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
+ (BOOL) A_CheckCanSendSMS {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];
}
+ (BOOL) A_CheckCanCall {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

@end
