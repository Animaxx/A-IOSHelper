A-IOSHelper [![Stories in Ready](https://badge.waffle.io/animaxx/a-ioshelper.svg?label=ready&title=Ready)](http://waffle.io/animaxx/a-ioshelper)  [![Build Status](https://travis-ci.org/Animaxx/A-IOSHelper.svg?branch=master)](https://travis-ci.org/Animaxx/A-IOSHelper)
===========

## Summary
The aim of the project provides base foundation functions for IOS developer to make developer build iOS app easier. I am trying hard to make it can be used for Objective-C and Swift projects.

More information: http://animaxx.github.io/A-IOSHelper

## How to use
In A-IOSHelper, all functions are having the A_prefix, so we can get advantage from IDE's hint.

For using this framework, you can compile it and add the compiled file, A_IOSHelper.framework, into your project at Project page -> General -> Target -> Embedded Binaries section. If your project is older then iOS 8.0, I recommend that copying whole source code to your project.

## How to compile 
Please use `build.sh` file to build this project.
> sh ./build.sh

OR
> sudo sh ./build.sh

and you may use following code to check the building result 
> cd Product/A_IOSHelper.framework

> lipo -info A_IOSHelper

It should shows `Architectures in the fat file: A_IOSHelper are: i386 x86_64 armv7 arm64`

## Brief Example
The Obecrive-C example:

`#import <A_IOSHelper/A_IOSHelper.h>` // Import A_IOSHelper.h is only needed. 

Get data from 2 web services concurrently, and when all of them completed, pop-up an alert view in main thread.

```Objective-C
[[[[A_TaskHelper A_Init:A_Task_RunInBackgroupCompleteInMain
                   Sequential:NO] A_AddTask:^(A_TaskHelper *task) {
    // Visit first service and store the result with the name "task1"
    [task A_Set:@"task1" Value:[A_RESTRequest A_GetArray:@"http://webservice_1"]];
}] A_AddTask:^(A_TaskHelper *task) {
    // Visit second service and store the result with the name "task2"
    [task A_Set:@"task2" Value:[A_RESTRequest A_GetDictionary:@"http://webservice_2"]];
}] A_ExecuteWithCompletion:^(A_TaskHelper *task) {
    // Merge two
    [UIAlertView A_DisplyAlert:[NSString stringWithFormat:@"%@ %@",
                                [task A_Get:@"task1"],
                                [task A_Get:@"task2"]]
                      AndTitle:@"Result"
                  CancelButton:@"Okay"];
}];
```

The Swfit example:

`import A_IOSHelper`

Download image and cache it, and it can get same image next time from cache instead of download again.

```Objective-C
A_ImageHelper.A_DownloadImageAndCache("http://animaxapps.appspot.com/img/Animax.png")
```


