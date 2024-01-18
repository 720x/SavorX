//
//  GCCControlView.m
//  RDPlayer
//
//  Created by 郭春城 on 16/10/20.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "GCCControlView.h"
#import "UIColor+YYAdditions.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

//static const CGFloat ControlViewHiddenAnimationTime = .3f;
static const CGFloat ControlViewHiddenWaitTime = 4.f;

@interface GCCControlView ()

@property (nonatomic, strong) UIView * toolView; //控件容器
@property (nonatomic, strong) UIView * endView; //结束视图
@property (nonatomic, strong) UIImageView * topImageView; //顶部阴影
@property (nonatomic, strong) UIView * bottomView; //底部阴影
@property (nonatomic, strong) UIProgressView * bufferView; //缓存进度条
@property (nonatomic, strong) UISlider * slider; //拖动进度控制条
@property (nonatomic, strong) UIButton * screenButton; //全屏切换按钮
@property (nonatomic, strong) UIButton * backButton; //返回按钮
//@property (nonatomic, strong) UILabel * titleLabel; //标题显示label
@property (nonatomic, strong) UILabel * timeLabel; //当前播放时间显示
@property (nonatomic, strong) UILabel * totalTimeLabel;
@property (nonatomic, strong) UIActivityIndicatorView * loadingView; //菊花状加载
@property (nonatomic, assign) NSInteger totalTime; //视频总时长
@property (nonatomic, strong) UIButton * replayButton; //重播按钮
@property (nonatomic, strong) UIButton * endShare; //结束时的分享按钮
@property (nonatomic, strong) UIButton * endCollect; //结束时的收藏按钮
@property (nonatomic, strong) UIButton * endBackButton; //结束时的返回按钮
//@property (nonatomic, strong) UIButton * shotButton; //截图按钮
@property (nonatomic, strong) UIButton * collectButton; //收藏按钮
@property (nonatomic, strong) UIButton * definitionButton; //清晰度按钮
@property (nonatomic, strong) UIView * selectView; //选择清晰度视图
@property (nonatomic, strong) UIButton * firstButton; //第一个清晰度button
@property (nonatomic, strong) UIButton * secondButton; //第二个清晰度button

@property (nonatomic, assign) BOOL isShow; //ToolView是否是显示状态
@property (nonatomic, assign) BOOL isAnimation; //是否正在进行显示或隐藏
@property (nonatomic, assign) BOOL isFullScreen; //是否全屏
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIProgressView * progressBG;
@property (nonatomic, strong) UIProgressView * progressView;

@property (nonatomic, strong) UIImageView * failedView;
@property (nonatomic, assign) BOOL isPlayFailed;

@end

@implementation GCCControlView

- (instancetype)init
{
    if (self = [super init]) {
        [self customControlView];
    }
    return self;
}

- (void)customControlView
{
    self.toolView = [[UIView alloc] init];
    [self addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.failedView = [[UIImageView alloc] init];
    self.failedView.userInteractionEnabled = YES;
    [self.toolView addSubview:self.failedView];
    [self.failedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView * blackView = [[UIView alloc] init];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    [self.failedView addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UILabel * label =  [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = kPingFangLight(15);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = RDLocalizedString(@"RDString_FailedWithAVPlayer");
    [self.failedView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(-20);
    }];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:VCBackgroundColor];
    button.titleLabel.font = kPingFangLight(14);
    [button setTitle:RDLocalizedString(@"RDString_ReLoad") forState:UIControlStateNormal];
    [button setTitleColor:kThemeColor forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.f;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(replayWhenFailed) forControlEvents:UIControlEventTouchUpInside];
    [self.failedView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
    
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.image = [UIImage imageNamed:@"topImageView"];
    self.topImageView.userInteractionEnabled = YES;
    [self.toolView addSubview:self.topImageView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    [self.toolView addSubview:self.bottomView];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"sp_zanting"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"sp_bofang"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    
    self.loadingView = [[UIActivityIndicatorView alloc] init];
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:self.loadingView];
    
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectButton setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"icon_collect_yes"] forState:UIControlStateSelected];
    [self.collectButton addTarget:self action:@selector(collectVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.topImageView addSubview:self.collectButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.topImageView addSubview:self.shareButton];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.slider = [[UISlider alloc] init];
    [self.slider setThumbImage:[UIImage imageNamed:@"bigSlider"] forState:UIControlStateNormal];
    self.slider.minimumTrackTintColor = kThemeColor;
    self.slider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    [self.slider setValue:0.f];
    // slider开始滑动事件
    [self.slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    self.slider.userInteractionEnabled = NO;
    [self.bottomView addSubview:self.slider];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"00:00";
    self.timeLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [self.bottomView addSubview:self.timeLabel];
    
    self.totalTimeLabel = [[UILabel alloc] init];
    self.totalTimeLabel.backgroundColor = [UIColor clearColor];
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.totalTimeLabel.text = @"00:00";
    self.totalTimeLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [self.bottomView addSubview:self.totalTimeLabel];
    
    self.bufferView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.bufferView.trackTintColor = [UIColor clearColor];
    self.bufferView.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    self.bufferView.userInteractionEnabled = NO;
    [self.bufferView setProgress:0.f];
    [self.slider addSubview:self.bufferView];
    
    self.progressBG = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressBG.trackTintColor = [UIColor clearColor];
    self.progressBG.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    self.progressBG.userInteractionEnabled = NO;
    [self.progressBG setProgress:0.f];
    [self addSubview:self.progressBG];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = kThemeColor;
    self.progressView.userInteractionEnabled = NO;
    [self.progressView setProgress:0.f];
    [self.progressBG addSubview:self.progressView];
    
    self.screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.screenButton setImage:[UIImage imageNamed:@"RDFullScreen"] forState:UIControlStateNormal];
    [self.screenButton setImage:[UIImage imageNamed:@"RDBackFullScreen"] forState:UIControlStateSelected];
    [self.screenButton addTarget:self action:@selector(screenButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.screenButton];
    
    self.definitionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.definitionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.definitionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.definitionButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHQD") forState:UIControlStateNormal];
    [self.definitionButton setImage:[UIImage imageNamed:@"RDUp"] forState:UIControlStateNormal];
    [self.definitionButton setImage:[UIImage imageNamed:@"RDDown"] forState:UIControlStateSelected];
    [self.definitionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.definitionButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [self.definitionButton addTarget:self action:@selector(changeVideoDefinition) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.definitionButton];
    self.definition = RDDefinitionHQD;
    self.definitionButton.hidden = YES;
    
    self.endView = [[UIView alloc] init];
    [self addSubview:self.endView];
    [self.endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.endView.backgroundColor = [UIColor blackColor];
    self.endView.hidden = YES;
    
    self.endCollect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.endCollect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endCollect setImage:[UIImage imageNamed:@"shipi_shc"] forState:UIControlStateNormal];
    [self.endCollect setImage:[UIImage imageNamed:@"shipi_yishc"] forState:UIControlStateSelected];
    self.endCollect.titleLabel.font = kPingFangLight(13);
    [self.endCollect setTitle:RDLocalizedString(@"RDString_Collect") forState:UIControlStateNormal];
    [self.endCollect addTarget:self action:@selector(collectVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.endView addSubview:self.endCollect];
    
    self.endShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.endShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endShare setImage:[UIImage imageNamed:@"shipi_fx"] forState:UIControlStateNormal];
    self.endShare.titleLabel.font = kPingFangLight(13);
    [self.endShare addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.endShare setTitle:RDLocalizedString(@"RDString_Share") forState:UIControlStateNormal];
    [self.endView addSubview:self.endShare];
    
    self.replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.replayButton setTitle:RDLocalizedString(@"RDString_RDRePlay") forState:UIControlStateNormal];
    self.replayButton.titleLabel.font = kPingFangLight(13);
    [self.replayButton setImage:[UIImage imageNamed:@"shipi_cb"] forState:UIControlStateNormal];
    [self.replayButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [self.endView addSubview:self.replayButton];
    
    self.endBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.endBackButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.endBackButton addTarget:self action:@selector(backButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.endView addSubview:self.endBackButton];
    
    [self.endCollect setImageEdgeInsets:UIEdgeInsetsMake(0, 2.5, 17, 0)];
    [self.endCollect setTitleEdgeInsets:UIEdgeInsetsMake(58, -45, 0, 0)];
    [self.endShare setImageEdgeInsets:UIEdgeInsetsMake(0, 2.5, 17, 0)];
    [self.endShare setTitleEdgeInsets:UIEdgeInsetsMake(58, -45, 0, 0)];
    [self.replayButton setImageEdgeInsets:UIEdgeInsetsMake(0, 2.5, 17, 0)];
    [self.replayButton setTitleEdgeInsets:UIEdgeInsetsMake(58, -45, 0, 0)];
    
    self.selectView = [[UIView alloc] init];
    self.selectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self.toolView addSubview:self.selectView];
    self.selectView.hidden = YES;
    
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.firstButton.tag = 101;
    [self.firstButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.firstButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHD") forState:UIControlStateNormal];
    [self.selectView addSubview:self.firstButton];
    
    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.secondButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.secondButton.tag = 102;
    [self.secondButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondButton setTitle:RDLocalizedString(@"RDString_RDDefinitionSD") forState:UIControlStateNormal];
    [self.selectView addSubview:self.secondButton];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-55);
        make.right.mas_equalTo(-50);
        make.size.mas_equalTo(CGSizeMake(50, 80));
    }];
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    [self.endCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-kMainBoundsWidth / 4);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    [self.endShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    [self.replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(kMainBoundsWidth / 4);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    [self.endBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.toolView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(55);
        make.centerY.equalTo(self.bottomView);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(15);
    }];
    [self.bufferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    [self.screenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.left.mas_equalTo(50);
//        make.right.mas_equalTo(-10);
//        make.height.mas_equalTo(20);
//    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.definitionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.right.mas_equalTo(-50);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-55);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.progressBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.isPlayFailed = NO;
    self.progressBG.alpha = 0.f;
    self.playButton.alpha = 0.f;
    self.isShow = YES;
//    [self waitToHiddenToolView];
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        [self playOrientationLandscape];
    }
}

- (void)backgroundImage:(NSString *)url
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    [self.endView insertSubview:self.imageView belowSubview:self.endCollect];
    self.endView.hidden = YES;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    if (![self.imageView viewWithTag:748]) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        view.tag = 748;
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        [self.imageView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
}

//截屏
- (void)shotScreenVideo
{
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shotButtonDidClicked)]) {
        [self.delegate shotButtonDidClicked];
    }
}

//投屏电视按钮被点击
- (void)TVButtonDidClicked
{
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(TVButtonDidClicked)]) {
        [self.delegate TVButtonDidClicked];
    }
}

- (void)collectVideo
{
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectButtonDidClicked:)]) {
        [self.delegate collectButtonDidClicked:self.collectButton];
    }
}

- (void)shareVideo
{
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareButtonDidClicked)]) {
        [self.delegate shareButtonDidClicked];
    }
}

//变成竖屏
- (void)playOrientationPortrait
{
    self.definitionButton.hidden = YES;
    self.screenButton.selected = NO;
    self.isFullScreen = NO;
//    self.titleLabel.hidden = YES;
    self.backButton.alpha = 1;
    
    if (!self.selectView.isHidden) {
        self.selectView.hidden = YES;
    }
    
    [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
//    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.right.mas_equalTo(-10);
//    }];
    [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
    }];
    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-80);
    }];
    [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.collectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-55);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
    }];
    [self.endCollect mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-kMainBoundsWidth / 4);
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    [self.endShare mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    [self.replayButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(kMainBoundsWidth / 4);
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    
    [self.playButton setImage:[UIImage imageNamed:@"sp_zanting"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"sp_bofang"] forState:UIControlStateSelected];
}

//变成横屏
- (void)playOrientationLandscape
{
    self.definitionButton.hidden = NO;
    self.definitionButton.selected = NO;
    self.screenButton.selected = YES;
    self.isFullScreen = YES;
//    self.titleLabel.hidden = NO;
    
    [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-100);
    }];
    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-150);
    }];
    [self.screenButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    self.backButton.alpha = self.toolView.alpha;
    
    [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.collectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.right.mas_equalTo(-60);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
    }];
    [self.endCollect mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-kMainBoundsWidth / 5);
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    [self.endShare mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    [self.replayButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(kMainBoundsWidth / 5);
        make.size.mas_equalTo(CGSizeMake(50, 70));
    }];
    
    [self.playButton setImage:[UIImage imageNamed:@"sp_zanting"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"sp_bofang"] forState:UIControlStateSelected];
}

- (void)setVideoIsCollect:(BOOL)isCollect
{
    if (isCollect) {
        [self.collectButton setSelected:YES];
        [self.collectButton setImage:[UIImage imageNamed:@"icon_collect_yes"] forState:UIControlStateNormal];
    }else{
        [self.collectButton setSelected:NO];
        [self.collectButton setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    }
    self.endCollect.selected = isCollect;
}

- (void)selectButtonDidClicked:(UIButton *)button
{
    if (button.tag == 101) {
        [SAVORXAPI postUMHandleWithContentId:@"details_page_mediation_clarity" key:@"details_page_mediation_clarity" value:@"hd"];
        switch (self.definition) {
            case RDDefinitionSD:
                [self changeToRDDefinitionHQD];
                break;
                
            case RDDefinitionHD:
                [self changeToRDDefinitionHQD];
                break;
                
            case RDDefinitionHQD:
                [self changeToRDDefinitionHD];
                break;
                
            default:
                break;
        }
        
    }else{
        
       [SAVORXAPI postUMHandleWithContentId:@"details_page_mediation_clarity" key:@"details_page_mediation_clarity" value:@"ld"];
        switch (self.definition) {
            case RDDefinitionSD:
                [self changeToRDDefinitionHD];
                break;
                
            case RDDefinitionHD:
                [self changeToRDDefinitionSD];
                break;
                
            case RDDefinitionHQD:
                [self changeToRDDefinitionSD];
                break;
                
            default:
                break;
        }
        
    }
    [self changeVideoDefinition];
}

- (void)changeToRDDefinitionSD
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playItemShouldChangeDefinitionTo:)]) {
        [self.delegate playItemShouldChangeDefinitionTo:10];
    }
    self.definition = RDDefinitionSD;
    [self.definitionButton setTitle:RDLocalizedString(@"RDString_RDDefinitionSD") forState:UIControlStateNormal];
    [self.firstButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHQD") forState:UIControlStateNormal];
    [self.secondButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHD") forState:UIControlStateNormal];
}

- (void)changeToRDDefinitionHD
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playItemShouldChangeDefinitionTo:)]) {
        [self.delegate playItemShouldChangeDefinitionTo:20];
    }
    self.definition = RDDefinitionHD;
    [self.definitionButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHD") forState:UIControlStateNormal];
    [self.firstButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHQD") forState:UIControlStateNormal];
    [self.secondButton setTitle:RDLocalizedString(@"RDString_RDDefinitionSD") forState:UIControlStateNormal];
}

- (void)changeToRDDefinitionHQD
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playItemShouldChangeDefinitionTo:)]) {
        [self.delegate playItemShouldChangeDefinitionTo:30];
    }
    self.definition = RDDefinitionHQD;
    [self.definitionButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHQD") forState:UIControlStateNormal];
    [self.firstButton setTitle:RDLocalizedString(@"RDString_RDDefinitionHD") forState:UIControlStateNormal];
    [self.secondButton setTitle:RDLocalizedString(@"RDString_RDDefinitionSD") forState:UIControlStateNormal];
}

- (void)changeVideoDefinition
{
    self.definitionButton.selected = !self.definitionButton.selected;
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
    if (self.definitionButton.selected) {
        self.selectView.hidden = NO;
    }else{
        self.selectView.hidden = YES;
    }
}

- (void)progressSliderTouchBegan:(UISlider *)slider
{
    if (!self.slider.isUserInteractionEnabled) {
        return;
    }
    self.isSlider = YES;
}

- (void)progressSliderValueChanged:(UISlider *)slider
{
    if (!self.slider.isUserInteractionEnabled) {
        return;
    }
    NSInteger currentTime = self.totalTime * self.slider.value;
    self.progressView.progress = self.slider.value;
    // 当前时长进度progress
    NSInteger proMin           = currentTime / 60;//当前秒
    NSInteger proSec           = currentTime % 60;//当前分钟
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
}

- (void)progressSliderTouchEnded:(UISlider *)slider
{
    if (!self.slider.isUserInteractionEnabled) {
        return;
    }
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
    self.isSlider = NO;
    NSInteger time = self.slider.value * self.totalTime;
    self.progressView.progress = self.slider.value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderDidSlideToTime:)]) {
        [self.delegate sliderDidSlideToTime:time];
    }
}

- (void)replayWhenFailed
{
    self.isPlayFailed = NO;
    self.endView.hidden = YES;
    [self showToolView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(replayButtonDidClickedWhenFailed)]) {
        [self.delegate replayButtonDidClickedWhenFailed];
    }
}

- (void)replay
{
    self.isPlayFailed = NO;
    self.endView.hidden = YES;
    [self showToolView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(replayButtonDidClicked)]) {
        [self.delegate replayButtonDidClicked];
    }
}

- (void)play
{
    [self.playButton setSelected:YES];
    if (!self.isShow) {
        [UIView animateWithDuration:.5f animations:^{
            self.playButton.alpha = 0;
        }];
    }
}

- (void)pause
{
    [self.playButton setSelected:NO];
    if (!self.isShow) {
        if (!self.loadingView.isAnimating) {
            self.playButton.alpha = 1.0;
        }
    }
}

- (void)videoDidInit
{
    [self stopLoading];
    self.playButton.alpha = 1.f;
}

- (void)stop
{
    [self stopLoading];
    [self.playButton setSelected:NO];
    self.endView.hidden = NO;
    [self.slider setValue:0.f];
    self.progressView.progress = self.slider.value;
    if (self.isFullScreen) {
        [self backButtonDidClicked:self.backButton];
    }
}

- (void)didPlayFailed
{
    [self.slider setValue:0.f];
    [self.playButton setSelected:NO];
    if (self.isFullScreen) {
        [self backButtonDidClicked:self.backButton];
    }
    [self stopLoading];
    self.playButton.alpha = 0.f;
    self.isPlayFailed = YES;
}

- (void)setVideoTotalTime:(NSInteger)time
{
    self.totalTime = time;
    NSInteger durMin           = time / 60;//总秒
    NSInteger durSec           = time % 60;//总分钟
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    self.slider.userInteractionEnabled = YES;
}

- (void)setBufferValue:(CGFloat)value
{
    [self.bufferView setProgress:value];
    [self.progressBG setProgress:value];
}

- (void)setVideoTitle:(NSString *)title
{
//    self.titleLabel.text = title;
}

- (void)setSliderValue:(CGFloat)value currentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime
{
    if (!self.isSlider) {
        self.totalTime = totalTime;
        // 当前时长进度progress
        NSInteger proMin           = currentTime / 60;//当前秒
        NSInteger proSec           = currentTime % 60;//当前分钟
        self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        [self.slider setValue:value];
        self.progressView.progress = self.slider.value;
    }
}

- (void)setSliderValue:(CGFloat)value
{
    [self.slider setValue:value];
    self.bufferView.progress = 0;
    self.progressBG.progress = 0;
    self.progressView.progress = self.slider.value;
    self.timeLabel.text = @"00:00";
}

- (void)loading
{
    if (!self.loadingView.isAnimating) {
        [self.loadingView startAnimating];
        self.playButton.alpha = 0.f;
    }
}

- (void)stopLoading
{
    if (self.loadingView.isAnimating) {
        [self.loadingView stopAnimating];
    }
}

- (void)seekTimeWithPause
{
    [self stopLoading];
    self.playButton.alpha = 1.f;
}

//播放暂停按钮被点击
- (void)playButtonDidClicked:(UIButton *)button
{
    if (button.isSelected) {
        button.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playButtonDidClickedToPause:)]) {
            [self.delegate playButtonDidClickedToPause:button];
        }
    }else{
        button.selected = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playButtonDidClickedToPlay:)]) {
            [self.delegate playButtonDidClickedToPlay:button];
        }
    }
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
}

//全屏切换按钮被点击
- (void)screenButtonDidClicked:(UIButton *)button
{
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenButtonDidClicked:)]) {
        [self.delegate screenButtonDidClicked:button];
    }
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
}

//返回按钮被点击
- (void)backButtonDidClicked:(UIButton *)button
{
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonDidClicked)]) {
        [self.delegate backButtonDidClicked];
    }
    [self cancleWaitToHiddenToolView];
    [self waitToHiddenToolView];
}

//延时等待控制栏隐藏
- (void)waitToHiddenToolView
{
    if (self.isShow) {
        [self performSelector:@selector(hiddenToolView) withObject:nil afterDelay:ControlViewHiddenWaitTime];
    }
}

//取消延时等待控制栏隐藏
- (void)cancleWaitToHiddenToolView
{
    if (self.isShow) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenToolView) object:nil];
    }
}

//改变控制栏显示状态
- (void)changeControlViewShowStatus
{
    if (self.isShow) {
        [self hiddenToolView];
    }else{
        [self showToolView];
    }
}

//演示控制栏
- (void)showToolView
{
    if (self.isAnimation || self.isPlayFailed) {
        return;
    }
    self.isAnimation = YES;
    if (self.definitionButton.isSelected) {
        self.definitionButton.selected = NO;
        self.selectView.hidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewStatusHidden:)]) {
        [self.delegate toolViewStatusHidden:NO];
    }
    
    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration animations:^{
        self.progressBG.alpha = 0.f;
        self.toolView.alpha = 1.0;
        if (!self.loadingView.isAnimating) {
            self.playButton.alpha = 1.0;
        }
        if (self.isFullScreen) {
            self.backButton.alpha = self.toolView.alpha;
        }
    } completion:^(BOOL finished) {
        self.isShow = YES;
        self.isAnimation = NO;
        [self cancleWaitToHiddenToolView];
        [self waitToHiddenToolView];
    }];
}

//隐藏控制栏
- (void)hiddenToolView
{
    if (self.isAnimation || self.isSlider || self.isPlayFailed) {
        return;
    }
    self.isAnimation = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewStatusHidden:)]) {
        [self.delegate toolViewStatusHidden:YES];
    }
    
    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration animations:^{
        self.progressBG.alpha = 1.f;
        self.toolView.alpha = 0;
        if (self.playButton.isSelected) {
            self.playButton.alpha = 0;
        }
        if (self.isFullScreen) {
            self.backButton.alpha = self.toolView.alpha;
        }
        if (self.isPlayFailed) {
            self.toolView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        self.isShow = NO;
        self.isAnimation = NO;
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (void)setIsPlayFailed:(BOOL)isPlayFailed
{
    _isPlayFailed = isPlayFailed;
    
    if (isPlayFailed) {
        self.toolView.alpha = 1;
        self.failedView.hidden = NO;
        self.bottomView.hidden = YES;
    }else{
        self.failedView.hidden = YES;
        self.bottomView.hidden = NO;
    }
}

#pragma mark 屏幕转屏相关

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self playOrientationLandscape];
        
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self playOrientationPortrait];
    }
}

@end
