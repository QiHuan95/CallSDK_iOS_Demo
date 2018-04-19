# CallSDK_iOS_Demo
## 概述

TILCallSDK基于[ILiveSDK](https://github.com/zhaoyang21cn/ILiveSDK_iOS_Demos)，实现双人视频(多人)业务功能封装，方便开发者快速搭建自己的视频聊天服务

![](http://mc.qcloudimg.com/static/img/eac611468f299d64923299a6873ee447/image.png)


## 集成
CallSDKDemo里面集成了ILiveSDK、AVSDK、IMSDK，执行Frameworks文件夹下的脚本loadSDK.sh下载。

```
sh loadSDK.sh
```

下载成功后的Frameworks文件夹目录如下：
```
AVSDK
ILiveSDK
IMSDK
TILCallSDK
loadSDK.sh
```

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

接口|所属类别|描述
:--|:--|:--:
setIncomingCallListener|TILCallManager|设置来电监听
makeCall:result:|TILC2CCall|发起通话
onC2CCallInvitation|TILCallIncomingCallListener|接听通话
cancelCall:|TILC2CCall|结束通话


## 快速接入
[视频聊天快速接入](https://github.com/zhaoyang21cn/CallSDK_iOS_Demo/blob/master/TILCallSDK-README.md)
