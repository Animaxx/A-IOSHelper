A-IOSHelper [![Stories in Ready](https://badge.waffle.io/animaxx/a-ioshelper.svg?label=ready&title=Ready)](http://waffle.io/animaxx/a-ioshelper)  [![Build Status](https://travis-ci.org/Animaxx/A-IOSHelper.svg?branch=master)](https://travis-ci.org/Animaxx/A-IOSHelper)
===========

## Summary
This is a scaffold framwork to make building iOS app quickly. It's built by Objective-c and you also can use for Swift project. The aid of the project is provide any fundation functions for IOS developer. 

## Reference libraries
If you use A_SqliteWrapper or A_DataMamager, please add `libsqlite3.dylib` to your project.

## How to use
In A-IOSHelper, all functions are having the prefix `A_` , so you can easy to find the function.

For import this framework, please copy whole framework into your project and add the framework in to Project -> General tab -> Embedded Binaries section.

The Obecrive-C example:

`#import <A_IOSHelper/A_IOSHelper.h>` // A_IOSHelper.h is only needed. 

// Examle of uploading a image

`[A_RESTRequest A_UploadImage:@"http://animaxapps.appspot.com/Upload/" QueryParameters:@{@"key1":@"value"} Headers:@{@"header1":@"value"} Image:image FileName:@"pic.png" FileKey:@"pic.png"]`

The Swfit example:

`import A_IOSHelper` // Also, you only need import the A_IOSHelper

// Example of downloading the image and cache it; when next time to get the same image, it will get the image from cache instead of download it again.

`A_ImageHelper.A_DownloadImageAndCache("http://animaxapps.appspot.com/img/Animax.png")`


## How to build 
Please use `build.sh` file to build this project.
> sh ./build.sh

OR
> sudo sh ./build.sh

and you may use following code to check the building result 
> cd Product/A_IOSHelper.framework

> lipo -info A_IOSHelper

It should shows `Architectures in the fat file: A_IOSHelper are: i386 x86_64 armv7 arm64`

