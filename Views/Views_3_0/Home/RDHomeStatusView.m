//
//  RDHomeStatusView.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/11.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDHomeStatusView.h"
#import "RDCheackSence.h"
#import "PhotoSliderViewController.h"
#import "GCCDLNA.h"
#import "RDAlertView.h"
#import "HSConnectViewController.h"

#import "DemandViewController.h"
#import "ScreenDocumentViewController.h"
#import "RDInteractionLoadingView.h"

@interface RDHomeStatusView ()

@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UIButton * statusButton;

@property (nonatomic, strong) UIViewController * currentVC;

@property (nonatomic, strong) RDCheackSence * checkSecen;

@end

@implementation RDHomeStatusView

+ (instancetype)defaultView
{
    static RDHomeStatusView *view;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        view = [[RDHomeStatusView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 48) status:RDHomeStatus_NoScene];
        
    });
    
    return view;
}

- (void)dealloc
{
    [self removeNotification];
}

- (instancetype)initWithFrame:(CGRect)frame status:(RDHomeStatusType)status
{
    if (self = [super initWithFrame:frame]) {
        self.status = status;
        [self createSelf];
    }
    return self;
}

- (void)createSelf
{
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, .5)];
    topLine.backgroundColor = UIColorFromRGB(0xdddbd8);
    [self addSubview:topLine];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - .5, self.frame.size.width, .5)];
    bottomLine.backgroundColor = UIColorFromRGB(0xece6de);
    [self addSubview:bottomLine];
    
    self.statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.statusButton setTitleColor:UIColorFromRGB(0x54453e) forState:UIControlStateNormal];
    self.statusButton.layer.borderColor = UIColorFromRGB(0xc4cdb9).CGColor;
    self.statusButton.layer.borderWidth = .5f;
    self.statusButton.layer.cornerRadius = 3;
    self.statusButton.layer.masksToBounds = YES;
    self.statusButton.titleLabel.font = kPingFangLight(14);
    [self.statusButton addTarget:self action:@selector(statusButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.statusButton.superview) {
        [self.statusButton removeFromSuperview];
    }
    [self addSubview:self.statusButton];
    
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(70);
    }];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = UIColorFromRGB(0x922c3e);
    self.statusLabel.font = kPingFangLight(14);
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusLabelDidClicked)];
    tap.numberOfTapsRequired = 1;
    [self.statusLabel addGestureRecognizer:tap];
    
    if (self.statusLabel.superview) {
        [self.statusLabel removeFromSuperview];
    }
    [self addSubview:self.statusLabel];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-13);
        make.right.equalTo(self.statusButton.mas_left).offset(-10);
    }];
    
    [self reloadStatus];
    
    [self addNotification];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qiutScreen) name:RDQiutScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeBind) name:RDDidDisconnectDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindBox) name:RDDidBindDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFoundBox) name:RDDidFoundHotelIdNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notFoundBox) name:RDDidNotFoundSenceNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDQiutScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidDisconnectDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidBindDeviceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidFoundHotelIdNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
}

- (void)didFoundBox
{
    self.status = RDHomeStatus_Normal;
    [self reloadStatus];
}

- (void)notFoundBox
{
    self.status = RDHomeStatus_NoScene;
    [self reloadStatus];
}

- (void)qiutScreen
{
    [self stopScreenWithStatus:RDHomeStatus_Bind];
}

- (void)bindBox
{
    self.status = RDHomeStatus_Bind;
    [self reloadStatus];
}

- (void)statusButtonDidClicked
{
    if (self.status == RDHomeStatus_Normal) {
        [self scanQRCode];
    }else if(self.status == RDHomeStatus_Bind){
        [self disconnentClick];
    }else{
        [self screenBack];
    }
}

- (void)statusLabelDidClicked
{
    if (self.currentVC) {
        [[Helper getRootNavigationController] pushViewController:self.currentVC animated:YES];
    }
}

// 断开连接
- (void)disconnentClick{
    
    RDAlertView *rdAlert = [[RDAlertView alloc] initWithTitle:RDLocalizedString(@"RDString_Alert") message:RDLocalizedString(@"RDString_DisconnectAlertDetail")];
    RDAlertAction *actionOne = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_Cancle") handler:^{
        [SAVORXAPI postUMHandleWithContentId:@"home_break_connect" key:@"home_break_connect" value:@"cancel"];
    } bold:NO];
    RDAlertAction *actionTwo = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_Disconnect") handler:^{
        [SAVORXAPI postUMHandleWithContentId:@"home_break_connect" key:@"home_break_connect" value:@"break"];
        [[GlobalData shared] disconnect];
    } bold:YES];
    NSArray *actionArr = [NSArray arrayWithObjects:actionOne,actionTwo, nil];
    [rdAlert addActions:actionArr];
    [rdAlert show];
}

// 断开连接
- (void)screenBack{
    
    RDAlertView *rdAlert = [[RDAlertView alloc] initWithTitle:RDLocalizedString(@"RDString_Alert") message:[NSString stringWithFormat:@"%@%@%@", RDLocalizedString(@"RDString_DidBackScreenAlertPre"), [Helper getWifiName], RDLocalizedString(@"RDString_DidBackScreenAlertSuf")]];
    RDAlertAction *actionOne = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_Cancle") handler:^{
        
    } bold:NO];
    RDAlertAction *actionTwo = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_BackScreen") handler:^{
        [SAVORXAPI ScreenDemandShouldBackToTVWithSuccess:^{
            [SAVORXAPI postUMHandleWithContentId:@"home_quick_back" key:nil value:nil];
        } failure:^{
            
        }];
    } bold:YES];
    NSArray *actionArr = [NSArray arrayWithObjects:actionOne,actionTwo, nil];
    [rdAlert addActions:actionArr];
    [rdAlert show];
}

- (void)reloadStatus
{
    switch (self.status) {
        case RDHomeStatus_NoScene:
        {
            [SAVORXAPI postUMHandleWithContentId:@"home_disconnect" key:nil value:nil];
            self.statusLabel.text = RDLocalizedString(@"RDString_NotScene");
            self.statusLabel.userInteractionEnabled = NO;
            self.statusButton.hidden = YES;
        }
            
            break;
        
        case RDHomeStatus_Normal:
        {
            [SAVORXAPI postUMHandleWithContentId:@"home_disconnect" key:nil value:nil];
            self.statusLabel.text = RDLocalizedString(@"RDString_StatusFindhotel");
            self.statusLabel.userInteractionEnabled = NO;
            self.statusButton.hidden = NO;
            [self.statusButton setTitle:RDLocalizedString(@"RDString_ConnetToTV") forState:UIControlStateNormal];
        }
            
            break;
            
        case RDHomeStatus_Bind:
        {
            [SAVORXAPI postUMHandleWithContentId:@"home_connect_tv" key:nil value:nil];
            self.statusLabel.text = [NSString stringWithFormat:@"%@--%@%@", RDLocalizedString(@"RDString_StatusHasConnectPre"), [Helper getWifiName], RDLocalizedString(@"RDString_StatusHasConnectSuf")];
            self.statusLabel.userInteractionEnabled = NO;
            self.statusButton.hidden = NO;
            [self.statusButton setTitle:RDLocalizedString(@"RDString_Disconnect") forState:UIControlStateNormal];
        }
            
            break;
            
        case RDHomeStatus_Photo:
        {
            [SAVORXAPI postUMHandleWithContentId:@"home_quick_entry" key:nil value:nil];
            self.statusLabel.text = [RDLocalizedString(@"RDString_StatusScreenPhoto") stringByAppendingString:@">>"];
            self.statusLabel.userInteractionEnabled = YES;
            self.statusButton.hidden = NO;
            [self.statusButton setTitle:RDLocalizedString(@"RDString_BackScreen") forState:UIControlStateNormal];
        }
            
            break;
            
        case RDHomeStatus_Video:
        {
            [SAVORXAPI postUMHandleWithContentId:@"home_quick_entry" key:nil value:nil];
            self.statusLabel.text = [RDLocalizedString(@"RDString_StatusScreenVideo") stringByAppendingString:@">>"];
            self.statusLabel.userInteractionEnabled = YES;
            self.statusButton.hidden = NO;
            [self.statusButton setTitle:RDLocalizedString(@"RDString_BackScreen") forState:UIControlStateNormal];
        }
            
            break;
            
        case RDHomeStatus_File:
        {
            [SAVORXAPI postUMHandleWithContentId:@"home_quick_entry" key:nil value:nil];
            self.statusLabel.text = [RDLocalizedString(@"RDString_StatusScreenFile") stringByAppendingString:@">>"];
            self.statusLabel.userInteractionEnabled = YES;
            self.statusButton.hidden = NO;
            [self.statusButton setTitle:RDLocalizedString(@"RDString_BackScreen") forState:UIControlStateNormal];
        }
            
            break;
            
        case RDHomeStatus_Demand:
        {
            [SAVORXAPI postUMHandleWithContentId:@"home_quick_video" key:nil value:nil];
            self.statusLabel.text = [RDLocalizedString(@"RDString_StatusDemandVideo") stringByAppendingString:@">>" ];
            self.statusLabel.userInteractionEnabled = YES;
            self.statusButton.hidden = NO;
            [self.statusButton setTitle:RDLocalizedString(@"RDString_BackDemand") forState:UIControlStateNormal];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

- (void)startScreenWithViewController:(UIViewController *)viewController withStatus:(RDHomeStatusType)status
{
    [self show];
    
//    [self stopScreen];
    
    if ([self.currentVC isKindOfClass:[PhotoSliderViewController class]]) {
        PhotoSliderViewController * vc = (PhotoSliderViewController *)self.currentVC;
        [vc shouldRelease];
    }else if ([self.currentVC isKindOfClass:[DemandViewController class]]) {
        DemandViewController * vc = (DemandViewController *)self.currentVC;
        [vc shouldRelease];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.currentVC = viewController;
    self.status = status;
    [self reloadStatus];
    
    _isScreening = YES;
}

- (void)closeBind
{
    [self stopScreenWithStatus:RDHomeStatus_Normal];
//    self.status = RDHomeStatus_Normal;
//    [self reloadStatus];
}

- (void)stopScreenWithStatus:(RDHomeStatusType)type
{
    if ([self.currentVC isKindOfClass:[PhotoSliderViewController class]]) {
        PhotoSliderViewController * vc = (PhotoSliderViewController *)self.currentVC;
        [vc shouldRelease];
    }else if ([self.currentVC isKindOfClass:[DemandViewController class]]) {
        DemandViewController * vc = (DemandViewController *)self.currentVC;
        [vc shouldRelease];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.currentVC = nil;
    _isScreening = NO;
//    if (self.superview) {
//        self.status = RDHomeStatus_Bind;
//    }else{
//        self.status = RDHomeStatus_Normal;
//    }
    self.status = type;
    [self reloadStatus];
}

- (void)stopScreenWithEggGame
{
    [self stopScreenWithStatus:RDHomeStatus_Bind];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)show
{
    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
        self.hidden = NO;
    }
}

- (void)hidden
{
    self.hidden = YES;
}

#pragma mark -- 二维码扫描
- (void)scanQRCode
{
    if ([GlobalData shared].networkStatus != RDNetworkStatusReachableViaWiFi) {
        [self goToSetting];
        return;
    }
    
    
    if ([GCCDLNA defaultManager].isSearch) {
        self.checkSecen = [[RDCheackSence alloc] init];
        [self.checkSecen startCheckSence];
        
        return;
    }
    
    if ([GlobalData shared].scene == RDSceneHaveRDBox) {
        [self callQRcodeFromPlatform];
    }else{
        RDAlertView * alert = [[RDAlertView alloc] initWithTitle:RDLocalizedString(@"RDString_Alert") message:RDLocalizedString(@"RDString_NotFoundTV")];
        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_IKnewIt") handler:^{
            
        } bold:YES];
        [alert addActions:@[action]];
        [alert show];
    }
}

- (void)callQRcodeFromPlatform
{
    
    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
        //判断用户当前是否允许小热点使用相机权限
        [self CameroIsReady];
        
    }else{
        [self goToSetting];
    }
}

//相机权限准备好，即调用TCP连接检测与UDP广播发送进行二维码呼出
- (void)CameroIsReady
{
    
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        [Helper interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    __block BOOL hasSuccess = NO; //记录是否呼码成功过
    __block NSInteger hasFailure = 0; //记录失败次数
    
    RDInteractionLoadingView * hud = [[RDInteractionLoadingView alloc] initWithView:[UIApplication sharedApplication].keyWindow title:@"正在呼出验证码"];
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/execute/call-tdc", [GlobalData shared].callQRCodeURL];
    [SAVORXAPI getWithURL:platformUrl parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hidden];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            HSConnectViewController * view = [[HSConnectViewController alloc] init];
            if (![[Helper getRootNavigationController].topViewController isKindOfClass:[HSConnectViewController class]]) {
                [[Helper getRootNavigationController] pushViewController:view animated:YES];
            }
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        
        if (error.code == -1009 || error.code == -1001) {
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出超时"];
        }else{
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出失败"];
        }
    }];
    
    NSString *hosturl = [NSString stringWithFormat:@"%@/command/execute/call-tdc", [GlobalData shared].secondCallCodeURL];
    [SAVORXAPI getWithURL:hosturl parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hidden];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            HSConnectViewController * view = [[HSConnectViewController alloc] init];
            if (![[Helper getRootNavigationController].topViewController isKindOfClass:[HSConnectViewController class]]) {
                [[Helper getRootNavigationController] pushViewController:view animated:YES];
                hasSuccess = YES;
            }
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        
        if (error.code == -1009 || error.code == -1001) {
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出超时"];
        }else{
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出失败"];
        }
    }];
    
    NSString *boxPlatformURL = [NSString stringWithFormat:@"%@/command/execute/call-tdc", [GlobalData shared].thirdCallCodeURL];
    [SAVORXAPI getWithURL:boxPlatformURL parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hidden];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            HSConnectViewController * view = [[HSConnectViewController alloc] init];
            if (![[Helper getRootNavigationController].topViewController isKindOfClass:[HSConnectViewController class]]) {
                [[Helper getRootNavigationController] pushViewController:view animated:YES];
                hasSuccess = YES;
            }
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        
        if (error.code == -1009 || error.code == -1001) {
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出超时"];
        }else{
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出失败"];
        }
    }];
    
    NSString *boxURL = [NSString stringWithFormat:@"%@/showCode?deviceId=%@", [GlobalData shared].boxCodeURL, [GlobalData shared].deviceID];
    [SAVORXAPI getWithURL:boxURL parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hidden];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            HSConnectViewController * view = [[HSConnectViewController alloc] init];
            if (![[Helper getRootNavigationController].topViewController isKindOfClass:[HSConnectViewController class]]) {
                [[Helper getRootNavigationController] pushViewController:view animated:YES];
                hasSuccess = YES;
            }
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        
        if (error.code == -1009 || error.code == -1001) {
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出超时"];
        }else{
            [hud hidden];
            [MBProgressHUD showTextHUDwithTitle:@"验证码呼出失败"];
        }
    }];
}

//前往系统WIFI设置
- (void)goToSetting
{
    if (SYSTEM_VERSION_LESS_THAN(@"10")) {
        //iOS10之前可以直接跳转系统WIFI设置
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:RDLocalizedString(@"RDString_Alert") message:@"请将手机连接至电视所在WiFi" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:RDLocalizedString(@"RDString_Cancle") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:RDLocalizedString(@"RDString_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [[Helper getRootNavigationController] presentViewController:alert animated:YES completion:nil];
    }else{
        //iOS10之后暂不支持直接跳转系统WIFI
        RDAlertView * alert = [[RDAlertView alloc] initWithTitle:RDLocalizedString(@"RDString_Alert") message:@"请前往手机设置，打开无线局域网，连接至与电视同一wifi下"];
        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_IKnewIt") handler:^{
            
        } bold:YES];
        [alert addActions:@[action]];
        [alert show];
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    self.status = RDHomeStatus_Normal;
    [self reloadStatus];
}

@end
