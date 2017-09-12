## IOS_TILCallSDK_ChangeList

###### V1.0.15(2017-09-12)
* 修复边界操作（如对方取消的时候接受）导致的状态不一致的问题（multicall和c2ccall）
 
###### V1.0.14(2017-09-07)
* 修复边界操作（如对方取消的时候接受）导致的状态不一致的问题
 
###### V1.0.12(2017-08-23)
* c2c call心跳消息改为在线消息

###### V1.0.11(2017-08-07)
* 修复调用sendGroupOnlineMessage导致crash的问题
* 修复对方挂断时偶现obj-msgSend crash问题
 
 
###### V1.0.10(2017-07-14)
* 将废弃以下接口<br>
(void)onMemberEnterCall:(NSArray*)members;<br>
(void)onMemberQuitCall:(NSArray*)members;<br>
* 修改- (NSArray*)getMembers;接口为获取历史邀请成员列表

###### V1.0.9(2017-06-22)
* 优化邀请逻辑，过滤无效邀请
* 优化通话边界值状态
* makecall成功后开始发送心跳
 
 
###### V1.0.8(2017-05-22)
* TILCallNotification增加callId用于区分当前的通知属于哪一个会话
* 信令时间戳统一为服务器时间戳
* TILCallBaseConfig增加设备控制字段
  * 是否开启摄像头autoCamera
  * 是否开启麦克风autoMic
  * 是否开启扬声器autoSpeaker
  * 摄像头方向cameraPos
  * 是否开启高音质autoHdAudio
* TILCallListener增加首帧回调

###### V1.0.7(2017-04-27)
* TILCallBaseConfig添加自动忙时回复配置isAutoResponseBusy 

###### V1.0.6(2017-02-13)
* 修复onNewMessages回调失败的问题 

###### V1.0.5(2017-1-19)
* 修复内部block循环引用问题
* 修复多人邀请，邀请失败仍能收到邀请信令的问题

###### V1.0.4(2017-1-16)
* 多人邀请时SDK内部添加自己到成员列表
* 修复成员邀请已退出的房主，房主收不到邀请信息的问题
* 修复多次房间内邀请，members参数未包含上次被邀请者id的问题
