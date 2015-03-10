A-IOSHelper [![Stories in Ready](https://badge.waffle.io/animaxx/a-ioshelper.svg?label=ready&title=Ready)](http://waffle.io/animaxx/a-ioshelper)  [![Build Status](https://travis-ci.org/Animaxx/A-IOSHelper.svg?branch=master)](https://travis-ci.org/Animaxx/A-IOSHelper)
===========

## Objective
The purpose of this project is providing a scaffold for iOS developer to build their IOS applications. This static library is using Objective-c, and you can also import into Swift project, and it also can be combine with other third-party frameworks safety.

## How to use
In A-IOSHelper, all functions have `A_` prefix, so you can easy to find the function by smart tips.

For import this framework, please copy whole framework into your project and add the framework in to Project -> General tab -> Embedded Binaries section.

Please see an Obecrive-C example below

`#import <A_IOSHelper/A_IOSHelper.h>` // the only head file you need to import is A_IOSHelper.h 

// Upload a image to server
`[A_RESTRequest A_UploadImage:@"http://animaxapps.appspot.com/Upload/" QueryParameters:@{@"key1":@"value"} Headers:@{@"header1":@"value"} Image:image FileName:@"pic.png" FileKey:@"pic.png"]`

Example for Swfit

`import A_IOSHelper` // Also, you only have to import the A_IOSHelper

// Download the image and cache it; when next time call this function, it will get the image from cache instead of download it again.
`A_ImageHelper.A_DownloadImageAndCache("http://animaxapps.appspot.com/img/Animax.png")`


## How to build 
Please use `build.sh` file to build this project.
> sh ./build.sh

and you may use following code to check the building result 
> cd Product/A_IOSHelper.framework

> lipo -info A_IOSHelper


