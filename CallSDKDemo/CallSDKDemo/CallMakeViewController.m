//
//  CallMakeViewController.m
//  TCILiveSDKDemo
//
//  Created by kennethmiao on 16/11/2.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "CallMakeViewController.h"

@interface CallMakeViewController () <TILCallNotificationListener,TILC2CCallStatusListener>
@property (nonatomic, strong) TILC2CCall *call;
@end

@implementation CallMakeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setEnableButton:NO];
    [self makeCall];
    
}

- (void)makeCall{
    TILC2CCallConfig * c2cConfig = [[TILC2CCallConfig alloc] init];
    TILC2CCallBaseConfig * baseConfig = [[TILC2CCallBaseConfig alloc] init];
    baseConfig.callType = TILCALL_TYPE_VIDEO;
    baseConfig.isSponsor = YES;
    baseConfig.peerId = self.peerId;
    baseConfig.heartBeatInterval = 3;
    c2cConfig.baseConfig = baseConfig;
    TILC2CCallListener * listener = [[TILC2CCallListener alloc] init];
    listener.callStatusListener = self;
    c2cConfig.callListener = listener;
    TILC2CSponsorConfig *sponsorConfig = [[TILC2CSponsorConfig alloc] init];
    sponsorConfig.waitLimit = 10;
    sponsorConfig.callId = (int)([[NSDate date] timeIntervalSince1970]) % 1000 * 1000 + arc4random() % 1000;
    sponsorConfig.onlineInvite = YES;
    c2cConfig.sponsorConfig = sponsorConfig;
    
    self.call = [[TILC2CCall alloc] initWithConfig:c2cConfig];
    UIView *baseView = [self.call createRenderViewIn:self.view];
    [self.view sendSubviewToBack:baseView];
    
    __weak typeof(self) ws = self;
    [self.call makeCall:nil custom:nil result:^(TILCallError *err) {
        if(err){
            ws.errLabel.text = [NSString stringWithFormat:@"code:%d,msg=%@",err.code,err.errMsg];
            [ws dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            self.errLabel.text = [NSString stringWithFormat:@"等待%@的接听",self.peerId];
            NSString *myId = [[ILiveLoginManager getInstance] getLoginId];
            [ws.call addRenderFor:myId atFrame:self.view.bounds];
        }
    }];
}

#pragma mark 设备操作（可使用ILiveRoomManager或TILC2CCall接口）
- (IBAction)closeCamera:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurCameraState];
    cameraPos pos = [manager getCurCameraPos];
    __weak typeof(self) ws = self;
    [manager enableCamera:pos enable:!isOn succ:^{
        ws.errLabel.text = !isOn?@"打开摄像头成功":@"关闭摄像头成功";
        [ws.closeCameraButton setTitle:(!isOn?@"关闭摄像头":@"打开摄像头") forState:UIControlStateNormal];
    }failed:^(NSString *moudle, int errId, NSString *errMsg) {
        ws.errLabel.text = [NSString stringWithFormat:@"moudle=%@,errId=%d,errMsg=%@",moudle,errId,errMsg];
    }];
}

- (IBAction)switchCamera:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    __weak typeof(self) ws = self;
    [manager switchCamera:^{
        ws.errLabel.text = @"切换摄像头成功";
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        ws.errLabel.text = [NSString stringWithFormat:@"moudle=%@,errId=%d,errMsg=%@",moudle,errId,errMsg];
    }];
}

- (IBAction)closeMic:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurMicState];
    __weak typeof(self) ws = self;
    [manager enableMic:!isOn succ:^{
        ws.errLabel.text = !isOn?@"打开麦克风成功":@"关闭麦克风成功";
        [ws.closeMicButton setTitle:(!isOn?@"关闭麦克风":@"打开麦克风") forState:UIControlStateNormal];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        ws.errLabel.text = [NSString stringWithFormat:@"moudle=%@,errId=%d,errMsg=%@",moudle,errId,errMsg];
    }];
}

- (IBAction)switchReceiver:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    __weak typeof(self) ws = self;
    QAVOutputMode mode = [manager getCurAudioMode];
    ws.errLabel.text = (mode == QAVOUTPUTMODE_EARPHONE?@"切换扬声器成功":@"切换到听筒成功");
    [ws.switchReceiverButton setTitle:(mode == QAVOUTPUTMODE_EARPHONE?@"切换到听筒":@"切换扬声器") forState:UIControlStateNormal];
    if(mode == QAVOUTPUTMODE_EARPHONE){
        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];
    }
    else{
        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];
    }
}

- (IBAction)setBeauty:(id)sender {
    self.errLabel.text = @"美颜功能暂时不支持";
}

- (IBAction)hangUp:(id)sender {
    __weak typeof(self) ws = self;
    [self.call hangup:^(TILCallError *err) {
        [ws dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)cancelInvite:(id)sender {
    __weak typeof(self) ws = self;
    [self.call cancelCall:^(TILCallError *err) {
        [ws dismissViewControllerAnimated:YES completion:nil];
    }];
}
//消息事件
- (void)onCallEstablish{
    self.errLabel.text = [NSString stringWithFormat:@"通话建立成功"];
    CGRect frame = CGRectMake(20, 20, 120, 160);
    [self.call addRenderFor:self.peerId atFrame:self.view.bounds];
    [self.call removeSelfRender];
    [self.call addSelfRender:frame];
    [self setEnableButton:YES];
}

- (void)onCallEnd:(TILC2CCallEndCode)code{
    switch (code) {
        case TILC2C_CALL_END_SPONSOR_TIMEOUT:
            self.errLabel.text = @"对方没有接听";
            break;
        case TILC2C_CALL_END_RESPONDER_REFUSE:
            self.errLabel.text = @"接受方已拒绝";
            break;
        case TILC2C_CALL_END_PEER_HANGUP:
            self.errLabel.text = @"对方已挂断";
            break;
        case TILC2C_CALL_END_RESPONDER_LINEBUSY:
            self.errLabel.text = @"对方正忙";
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setEnableButton:(BOOL)isMake{
    self.cancelInviteButton.enabled = !isMake;
    self.hungUpButton.enabled = isMake;
}
@end
