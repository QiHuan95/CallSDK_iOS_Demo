# CallSDK_iOS_Demo
## 概述

TILCallSDK基于[ILiveSDK](https://github.com/zhaoyang21cn/ILiveSDK_iOS_Demos)，实现双人视频(多人)业务功能封装，方便开发者快速搭建自己的视频聊天服务

![](http://mc.qcloudimg.com/static/img/eac611468f299d64923299a6873ee447/image.png)
 
## API文档
 
[TILCallSDK API文档](https://zhaoyang21cn.github.io/iLiveSDK_Help/ios_callsdk_help/)

## 集成
CallSDKDemo里面集成了第三方库，下载CallSDKDemo工程之后,需要再次下载相关的SDK放到指定的目录下。

1、[ILiveSDK、AVSDK、IMSDK下载](https://github.com/zhaoyang21cn/iLiveSDK_iOS_Suixinbo)

2、[TILCallSDK_1.0.15下载](http://dldir1.qq.com/hudongzhibo/ILiveSDK/TILCallSDK_1.0.15.zip)

下载成功之后解压放到工程目录的Frameworks文件夹下，如下图所示：
Frameworks目录

![](http://mc.qcloudimg.com/static/img/65349e480c8cb235f54615c55931aa2d/image.png)

AVSDK目录（**AVSDK1.9.0需要添加QAVEffect文件夹下的opencv2.framework以及添加系统包AssersLibrary.framework**）
 
![](http://mc.qcloudimg.com/static/img/6285a0b1b22a75536c4f8c8e0650cc92/image.png)

IMSDK目录

![](http://mc.qcloudimg.com/static/img/153f848ce2135a6427d2b455bc03aa94/image.png)

## 功能概述

TILCallSDK可以使用ILiveSDK的所有功能:
>* 帐号体系(资料托管)
>* 个人关系链
>* 群组管理
>* 音视频通讯
>* 美颜/美白
>* 视频推流/录制

效果图:

![](http://mc.qcloudimg.com/static/img/394688c8f4fe587fc73240b0d61e00d8/image.png)
![](http://mc.qcloudimg.com/static/img/a4e9ddfb28e4512870dae7eceba9666a/image.png)


## 主要接口介绍

登录相关请参考ILiveSDK：[https://github.com/zhaoyang21cn/ILiveSDK_iOS_Demos/blob/master/ILiveSDK-README.md)

接口|所属类别|描述
:--|:--|:--:
setIncomingCallListener|TILCallManager|设置来电监听
makeCall: custom: result:|TILC2CCall|发起通话
onC2CCallInvitation|LiveIncomingCallListener|接听通话
cancelCall:|TILC2CCall|结束通话


## 快速接入
请移步[视频聊天快速接入](https://github.com/zhaoyang21cn/CallSDK_iOS_Demo/blob/master/TILCallSDK-README.md)
