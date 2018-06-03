# A-IOSHelper [![Stories in Ready](https://badge.waffle.io/animaxx/a-ioshelper.svg?label=ready&title=Ready)](http://waffle.io/animaxx/a-ioshelper)
[![Waffle.io - Columns and their card count](https://badge.waffle.io/animaxx/a-ioshelper.svg?columns=all)](https://waffle.io/animaxx/a-ioshelper)

[![codecov](https://codecov.io/gh/Animaxx/A-IOSHelper/branch/master/graph/badge.svg)](https://codecov.io/gh/Animaxx/A-IOSHelper) [![Build Status](https://travis-ci.org/Animaxx/A-IOSHelper.svg?branch=master)](https://travis-ci.org/Animaxx/A-IOSHelper) [![cocoapods](https://img.shields.io/cocoapods/v/A_IOSHelper.svg)](https://cocoapods.org/pods/A_IOSHelper)

===========

## Summary
The aim of the project provides base foundation functions for IOS developer to make developer build iOS app easier. I am trying hard to make it can be used for Objective-C and Swift projects.

All functions are having the 'A_' prefix, so we can get advantage from code intellisense.

More information: http://animaxx.github.io/A-IOSHelper

## Contents
* [Animation](http://animaxx.github.io/A-IOSHelper/animation_example.html) - Animation helper provides easy way to set CALayer value animatingly and animation effects.
* [Event](http://animaxx.github.io/A-IOSHelper/event_example.html) - It provides a easy way to add and remove a blocking to UIControl event.
* [KVO Binding](http://animaxx.github.io/A-IOSHelper/kvo_example.html) - provides changed notification and objects binding method with blocks.
* [Task](http://animaxx.github.io/A-IOSHelper/task_example.html) - Tasks helper provides simple implement of tasks chain with async and sync.
* [Sqlite Manager](http://animaxx.github.io/A-IOSHelper/sqliteManager_example.html) - Sqlite Manager not only provides the base CRUD Sqlite operations but also provides data model searching and storing functions.
* [Data Model](http://animaxx.github.io/A-IOSHelper/datamodel_example.html) - When an object inherited DataModel, then it able to save the instance to plist file or sqlite database directly.
* [Network](http://animaxx.github.io/A-IOSHelper/network_example.html) - It provides easy RESTful API operation with JSON auto-serializing function.
* [Collection](http://animaxx.github.io/A-IOSHelper/collection_example.html) - It imitates the Linq in .Net to provide such Where, Any, Skip, and other assisting functions for NSArray and NSDictionary.

## Brief Example
###### The Obecrive-C example:

`#import <A_IOSHelper/A_IOSHelper.h>` // Import A_IOSHelper.h is only needed. 

Wait 0.6 seconds and do the zoom in with changing position and size animation. 

```Objective-C
[A_TaskHelper A_Delay:.6f RunInMain:^{
    [demo A_AnimationEffect:A_AnimationEffectType_zoomIn CompletionBlock:^{
        [demo.layer A_AnimationSetPositionX:200.0f 
        			AnimtionType:A_AnimationType_easeOutQuad];
        [demo.layer A_AnimationSetSize:CGSizeMake(100, 100) 
        			AnimtionType:A_AnimationType_spring];
    }];
}];
```

![animationDemo](http://animaxx.github.io/A-IOSHelper/images/demo/animationDemo.gif)


###### The Swfit example:

Add `<A_IOSHelper/A_IOSHelper.h>` to **Objective-C Bridging Header** in **Swift Compiler - Code Generation** section.

Download image and cache it, and it can get same image next time from cache instead of download again.

```Objective-C
A_ImageHelper.A_DownloadImageAndCache("http://animaxapps.appspot.com/img/Animax.png")
```



## Installation 
#### [CocoaPods](https://github.com/CocoaPods/CocoaPods)

Add the following line in your `Podfile`.

```
use_frameworks!
target 'YOUR_PROJECT_NAME' do
	pod "A_IOSHelper"
end
``` 

If using A_IOSHelper in Swift project, don't forget add this framework in Project page -> General -> Target -> Linked Frameworks and Libraries section. Otherwise, it will cause **unrecognized selector sent to class** error when you call any method in A_IOSHelper. 

#### Embedded framework file

Download [compiled framework file](http://animaxx.github.io/A-IOSHelper/release/A_IOSHelper.framework.zip) and put it
into your project in Project page -> General -> Target -> Embedded Binaries section. 


## Compile by yourself
Please use `build.sh` file to build this project.
> sh ./build.sh

OR
> sudo sh ./build.sh

and you may use following code to check the building result 
> cd Product/A_IOSHelper.framework

> lipo -info A_IOSHelper

It should shows `Architectures in the fat file: A_IOSHelper are: i386 x86_64 armv7 arm64`


## License
All source code is licensed under the [MIT License](https://github.com/Animaxx/A-IOSHelper/blob/master/LICENSE).

