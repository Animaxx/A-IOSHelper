A-IOSHelper
===========

## Objective
The purpose of this project is helping iOS developer easier to develop thier IOS applications. This static library is simple and esay to setup and use in any iOS projects, and it also easy and safety to combine with other third-party frameworks.

## How to use
In A-IOSHelper, all classes and functions have `A_` prefix, so you can easy to find the function by smart tips.

Please see a sample below  
`#import "A_IOSHelper.h"` // only need to import A_IOSHelper.h

`[A_ImageHelper A_DownloadImageAndCache:@"http://xxxx.png"];` // This simple code is going to download the image and cache it. When next time call this function, it will get the image from cache and not have to download again.

## Building 
Please use `build_lib.sh` file to build this project and get static library that support armv7 armv7s i386 x86_64 arm64.
> sh ./build_lib.sh

and you may use following code to check the building result 
> lipo -info libA-IOSHelper.a 
