
简介：TILCallSDK在ILiveSDK能力平台上，致力于提供一套完整的双人音视频即时通讯解决方案，提供“连麦”，“消息”，打造跨平台的通话场景。TILCallSDK旨在无限可能的降低用户接入成本，从用户角度考虑问题，全方位考虑用户接入体验，并提供接入服务专业定向支持，为用户应用上线保驾护航，本文档目的在于帮助用户快速接入使用TILCallSDK,达到发起方请求通话、接受方响应通话的效果。

----------

## 1. 预先集成ILiveSDK

用户在使用TILCallSDK前需要预先集成、初始化和登录ILiveSDK，[集成ILiveSDK步骤](https://github.com/zhaoyang21cn/ILiveSDK_iOS_Demos/blob/master/ILiveSDK-README.md)。


## 2. TILCallSDK集成和使用

### 2.1 集成TILCallSDK

使用TILCallSDK时只需考虑4个步骤：监听来电、发起通话、接听通话和结束通话。

### 2.2 设置来电监听

```
@interface TILCallManager : NSObject

/**
设置来电监听

@param listener 来电监听
*/
- (void)setIncomingCallListener:(id<TILCallIncomingCallListener>)listener;

@end

/**
来电监听协议
*/
@protocol TILCallIncomingCallListener <NSObject>
@optional
/**
监听来电（双人
@param invitation 来电邀请
*/
- (void)onC2CCallInvitation:(TILCallInvitation*)invitation;

/**
监听来电（多人）
@param invitation 来电邀请
*/
- (void)onMultiCallInvitation:(TILCallInvitation*)invitation;
@end


```

**参数说明：**

参数 | 说明
--- | ---  
| listener | TILCallIncomingCallListener，监听收到的通话请求

通话请求对象TILC2CCallInvitation的定义如下：

```

/**
通话邀请
*/
@interface TILCallInvitation : NSObject

/**
通话id
*/
@property(nonatomic,assign) int callId;

/**
通话类型
*/
@property(nonatomic,assign) TILCallType callType;

/**
发起者id（最初通话的发起者）
*/
@property(nonatomic,strong) NSString *sponsorId;

/**
邀请者id（双人call和sponsorId相同）
*/
@property(nonatomic,strong) NSString *inviterId;

/**
groupId（多人专用）
*/
@property(nonatomic,strong) NSString * groupId;

/**
所有参与者（多人专用）
*/
@property(nonatomic,strong) NSArray * memberArray;

/**
通话信息
*/
@property(nonatomic,strong) NSString * callTip;

/**
邀请时间
*/
@property(nonatomic,strong) NSDate * inviteDate;

/**
自定义信息
*/
@property(nonatomic,strong) NSString * custom;

@end

```

### 2.3 如何实现发起通话业务

以下以双人通话为例。

1 发起通话邀请
```
TILCallConfig * config = [[TILCallConfig alloc] init];
TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
baseConfig.callType = TILCALL_TYPE_VIDEO;
baseConfig.isSponsor = YES;
baseConfig.peerId = _peerId;
baseConfig.heartBeatInterval = 15;
config.baseConfig = baseConfig;

TILCallListener * listener = [[TILCallListener alloc] init];
//注意：
//［通知回调］可以获取通话的事件通知，建议双人和多人都走notifListener
// [通话状态回调] 也可以获取通话的事件通知
listener.callStatusListener = self;
listener.memberEventListener = self;
listener.notifListener = self;
config.callListener = listener;

TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
sponsorConfig.waitLimit = 10;
sponsorConfig.callId = (int)([[NSDate date] timeIntervalSince1970]) % 1000 * 1000 + arc4random() % 1000;
sponsorConfig.onlineInvite = YES;
config.sponsorConfig = sponsorConfig;

_call = [[TILC2CCall alloc] initWithConfig:config];
[_call createRenderViewIn:self.view];
[_call makeCall:nil custom:nil result:^(TILCallError *err) {
if(err){
NSLog(@"呼叫失败");
}
else{
NSLog(@"呼叫成功");
}
}];

```

<span id="TILMakeCallParam"></span>
参数  | 说明
--- | ---
callType | 语音类型或者为音视频类型 
isSponsor | 是否为通话发起者 
peerId | 接收方的identifier
haertBeatInterval | 心跳间隔，s为单位
notifListener | 心跳及自定义通知监听器
memberEventListener | 通话内成员音视频数据开关监听器
waitLimit | 发起通话的超时时间，超时后进入onCallEnd:回调
callId | 通话ID，全局唯一
onlineInvite | 是否在线邀请

2 监听事件回调

```
#pragma mark - 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{

}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
if(isOn){
for (TILCallMember *member in members) {
NSString *identifier = member.identifier;
if([identifier isEqualToString:_myId]){
[_call addRenderFor:_myId atFrame:self.view.bounds];
[_call sendRenderViewToBack:_myId];
}
else{
[_call addRenderFor:identifier atFrame:CGRectMake(20, 20, 120, 160)];
}
}
}
else{
for (TILCallMember *member in members) {
NSString *identifier = member.identifier;
[_call removeRenderFor:identifier];
}
}
}
```

**主意事项：**
1. callId同ILiveSDK中roomId概念一致，全局保持唯一。
2. 发起方需要设置isSponsor、callType、peerId、和sponsorConfig，否则不能正常工作。

### 2.4 如何实现接听通话业务

1 收到通话邀请
```

@implementation CallIncomingListener
- (void)onC2CCallInvitation:(TILCallInvitation *)invitation
{
//收到双人通话邀请
}

- (void)onMultiCallInvitation:(TILCallInvitation *)invitation
{
//收到多人通话邀请
}

```

2 接受电话邀请

```
//初始化配置参数
TILCallConfig * config = [[TILCallConfig alloc] init];
TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
baseConfig.callType = TILCALL_TYPE_VIDEO;
baseConfig.isSponsor = NO;
baseConfig.memberArray = _invite.memberArray;
baseConfig.heartBeatInterval = 15;
config.baseConfig = baseConfig;

TILCallListener * listener = [[TILCallListener alloc] init];
listener.memberEventListener = self;
listener.notifListener = self;
config.callListener = listener;

TILCallResponderConfig * responderConfig = [[TILCallResponderConfig alloc] init];
responderConfig.callInvitation = _invite;
config.responderConfig = responderConfig;

_call = [[TILMultiCall alloc] initWithConfig:config];
[_call createRenderViewIn:self.view];
[_call accept:^(TILCallError *err) {
if(err){
NSLog(@"接受失败");
}
else{
NSLog(@"接受成功");
}
}];
```

参数  | 说明
--- | ---
invitation | 捕获到的来电邀请对象 
其他参数 | 参考[发起通话参数列表](#TILMakeCallParam)

3 事件监听回调

```
#pragma mark - 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{

}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
if(isOn){
for (TILCallMember *member in members) {
NSString *identifier = member.identifier;
if([identifier isEqualToString:_myId]){
[_call addRenderFor:_myId atFrame:self.view.bounds];
[_call sendRenderViewToBack:_myId];
}
else{
[_call addRenderFor:identifier atFrame:CGRectMake(20, 20, 120, 160)];
}
}
}
else{
for (TILCallMember *member in members) {
NSString *identifier = member.identifier;
[_call removeRenderFor:identifier];
}
}
}
```

**主意事项：**
1. 接收方需要设置isSponsor、callType、peerId、responderConfig，否则不能正常工作。

### 2.5 如何结束通话

对于发起方，如果希望在对方相应通话请求前取消通话，需要调用如下接口。

**取消通话邀请：**

```
@interface TILC2CCall : TILBaseCall

/**
取消通话邀请

@param result 取消结果
*/
- (void)cancelCall:(TILResultBlock)result;

@end

```

在其他情况下，调用如下接口。

**挂断通话：**

```
@interface TILC2CCall : TILBaseCall

/**
挂断通话

@param result 挂断结果
*/
- (void)hangup:(TILResultBlock)result;

@end

```

至此，可以实现双人音视频通话功能，更多功能请下载demo体验。
