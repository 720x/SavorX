//
//  GCCPlayerView.m
//  RDPlayer
//
//  Created by 郭春城 on 16/10/17.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "GCCPlayerView.h"
#import "Masonry.h"
#import "GCCControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RDPhotoTool.h"
#import "ZFBrightnessView.h"
#import "ZFVolumeView.h"
#import "RDLogStatisticsAPI.h"
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger, GCCPlayerStatus) {
    GCCPlayerStatusInitial, //初始状态
    GCCPlayerStatusPlaying, //正在播放
    GCCPlayerStatusPause, //播放暂停
    GCCPlayerStatusEnd, //播放结束
    GCCPlayerStatusFaild //加载视频出错
};

@interface GCCPlayerView ()<GCCControlViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString * currentURL;
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) GCCPlayerStatus status; //当前播放状态
@property (nonatomic, strong) GCCControlView * controlView;
@property (nonatomic, strong) id timeObserve;
@property (nonatomic, strong) UISlider * volumeViewSlider; //记录系统音量视图
@property (nonatomic, strong) ZFBrightnessView * brightnessView;
@property (nonatomic, assign) CGFloat sumTime; //当前用户横向操作的时长
@property (nonatomic, strong) UILabel * sliderLabel; //用户快进快退提示
@property (nonatomic, assign) BOOL canPlay; //是否可以播放
@property (nonatomic, strong) AVPlayerItemVideoOutput * playerItemVideoOutput;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap; //屏幕单击事件
@property (nonatomic, strong) UITapGestureRecognizer * doubleTap; //屏幕双击事件
@property (nonatomic, strong) UIPanGestureRecognizer * panRecognizer; //屏幕滑动事件
@property (nonatomic, assign) GCCPlayerStatus lastStutas; //上一次进入后台前状态
@property (nonatomic, assign) BOOL isPan; //是否在进行pan手势
@property (nonatomic, assign) BOOL isHorizontal; //用户手指是否是水平移动
@property (nonatomic, assign) BOOL isVolume; //记录当前是否在调节时间
@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, assign) CMTime time;

@end

@implementation GCCPlayerView

- (instancetype)initWithURL:(NSString *)url
{
    if (self = [super init]) {
        self.status = GCCPlayerStatusInitial;
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        self.controlView = [[GCCControlView alloc] init];
        self.controlView.delegate = self;
        [self addSubview:self.controlView];
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
        [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(155);
            make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        // 单击
        self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidBeSingleClicked)];
        self.singleTap.numberOfTouchesRequired = 1; //手指数
        self.singleTap.numberOfTapsRequired    = 1;
        [self addGestureRecognizer:self.singleTap];
        [self configureVolume];
    }
    return self;
}

- (void)backgroundImage:(NSString *)url
{
    [self pause];
    [self.controlView setSliderValue:0.f];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    [self insertSubview:self.imageView belowSubview:self.controlView];
    [self.controlView backgroundImage:url];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    if ([self.imageView viewWithTag:6666]) {
        [[self.imageView viewWithTag:6666] removeFromSuperview];
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.tag = 6666;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [self.imageView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setPlayItemWithURL:(NSString *)url
{
    self.isPan = NO;
    NSString * preCheck = [url substringToIndex:url.length - 8];
    if ([self.currentURL hasPrefix:preCheck]) {
        self.time = CMTimeMake(self.player.currentTime.value / self.player.currentTime.timescale, 1);
    }else{
        self.time = kCMTimeZero;
    }
    self.currentURL = url;
    NSURL * playURL = [NSURL URLWithString:url];
    self.canPlay = NO;
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:playURL];
    if (self.player) {
        [playerItem removeOutput:self.playerItemVideoOutput];
//        [self.player pause];
        [self.controlView loading];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
    }else{
        [self.controlView loading];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区有足够数据可以播放了
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    self.playerItemVideoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:nil];
    [playerItem addOutput:self.playerItemVideoOutput];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 移除time观察者
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [self createTimer];
}

- (void)setVideoTitle:(NSString *)title
{
    [self.controlView setVideoTitle:title];
}

- (void)setIsCollect:(BOOL)isCollect
{
    [self.controlView setVideoIsCollect:isCollect];
}

- (void)setCollectEnable:(BOOL)enable
{
    [self.controlView.shareButton setUserInteractionEnabled:enable];
}

- (void)createTimer
{
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        if (weakSelf.isPan) {
            return;
        }
        AVPlayerItem *currentItem = weakSelf.player.currentItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.controlView setSliderValue:value currentTime:currentTime totalTime:totalTime];
            [weakSelf.controlView stopLoading];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                [self.player seekToTime:self.time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    
                }];
                
                //最开始播放
                self.canPlay = YES;
                CGFloat totalTime = self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
                [self.controlView setVideoTotalTime:totalTime];
                [self.controlView videoDidInit];
                [self createGesture];
            }else if (self.player.currentItem.status == AVPlayerItemStatusFailed){
                //播放失败
                self.status = GCCPlayerStatusFaild;
            }
            
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.player.currentItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            [self.controlView setBufferValue:timeInterval / totalDuration];
            
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
            
            // 当缓冲是空的时候
            if (self.player.currentItem.playbackBufferEmpty) {
                [self.controlView loading];
            }
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
            
            // 当缓冲好的时候
            if (self.player.currentItem.playbackLikelyToKeepUp){
                if (self.status == GCCPlayerStatusPlaying) {
                    [self.controlView stopLoading];
                }else{
                    [self.controlView seekTimeWithPause];
                }
            }else{
                [self.controlView loading];
            }
        }
    }
}

- (void)moviePlayDidEnd
{
    [self stop];
}

/**
*  计算缓冲进度
*
*  @return 缓冲进度
*/
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)createGesture
{
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidBeDoubleClicked)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    
    //滑动(音量/快进快退)
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    self.panRecognizer.delegate = self;
    
//    if (self.isFullScreen) {
        [self addGestureRecognizer:self.doubleTap];
        [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
        
        [self addGestureRecognizer:self.panRecognizer];
//    }
    
    //快进快退提示
    self.sliderLabel = [[UILabel alloc] init];
    self.sliderLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.text = @" >> 00:45/03:10";
    self.sliderLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:25];
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.sliderLabel];
    self.sliderLabel.hidden = YES;
    [self.sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }else if ([touch.view isKindOfClass:[UISlider class]]){
        return NO;
    }else if (self.status == GCCPlayerStatusEnd){
        return NO;
    }
    return YES;
}

////添加屏幕双击，滑动等手势
//- (void)addUserActionForView
//{
//    if (self.doubleTap) {
//        [self addGestureRecognizer:self.doubleTap];
//        // 双击失败响应单击事件
//        [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
//    }
//    if (self.panRecognizer) {
//        [self addGestureRecognizer:self.panRecognizer];
//    }
//}

////移除屏幕双击，滑动等手势
//- (void)removeUserActionView
//{
//    [self removeGestureRecognizer:self.doubleTap];
//    [self removeGestureRecognizer:self.panRecognizer];
//}

//屏幕单击响应事件
- (void)viewDidBeSingleClicked
{
    [self.controlView changeControlViewShowStatus];
}

//屏幕双击响应事件
- (void)viewDidBeDoubleClicked
{
    if (self.status == GCCPlayerStatusPause) {
        [SAVORXAPI postUMHandleWithContentId:@"details_page_play_video" key:nil value:nil];
        [self play];
    }else if (self.status == GCCPlayerStatusPlaying){
        [SAVORXAPI postUMHandleWithContentId:@"details_page_pause_touch" key:nil value:nil];
        [self pause];
    }
}

- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    static CGPoint center;
    
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动, 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            center = pan.view.center;
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) {
                self.isPan = YES;
                self.isHorizontal = YES;
                // 给sumTime初值
                CMTime time       = self.player.currentTime;
                self.sumTime      = time.value/time.timescale;
            }else{
                self.isHorizontal = NO;
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                    if (self.brightnessView.alpha != 0.f) {
                        self.brightnessView.alpha = 0.f;
                    }
                }else{
                    self.isVolume = NO;
//                    if (self.volumeView.alpha != 0.f) {
//                        self.volumeView.alpha = 0.f;
//                    }
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (self.isHorizontal) {
                [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
            }else{
                [self verticalMoved:veloctyPoint.y]; // 垂直移动的方法只要y方向的值
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            self.isPan = NO;
            if (self.isHorizontal) {
                [self sliderDidSlideToTime:self.sumTime];
                self.sumTime = 0;
                [self horizontalIsEnd];
            }else{
                [self verticalMoved:veloctyPoint.y]; // 垂直移动的方法只要y方向的值
                self.isVolume = NO;
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        {
            self.isPan = NO;
            self.sliderLabel.hidden = YES;
            self.isVolume = NO;
        }
            break;
            
        default:
            break;
    }
}

//用户手指横向滑动的时候
- (void)horizontalMoved:(CGFloat)value
{
    
    // 需要限定sumTime的范围
    CMTime totalTime           = self.player.currentItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    // 每次滑动需要叠加时间
    self.sumTime += value / 300.f;
    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }
    if (self.sumTime < 0) {
        self.sumTime = 0;
    }
    
    if (value > 0) {
        [self.controlView setSliderValue:(CGFloat)self.sumTime/(CGFloat)totalMovieDuration currentTime:self.sumTime totalTime:totalMovieDuration];
        [self showSliderLabelWithCurrentTime:self.sumTime totalTime:totalMovieDuration isForward:YES];
    }
    if (value < 0) {
        [self.controlView setSliderValue:(CGFloat)self.sumTime/(CGFloat)totalMovieDuration currentTime:self.sumTime totalTime:totalMovieDuration];
        [self showSliderLabelWithCurrentTime:self.sumTime totalTime:totalMovieDuration isForward:NO];
    }
}

- (void)showSliderLabelWithCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime isForward:(BOOL)isForward
{
    // 当前时长进度progress
    NSInteger proMin           = currentTime / 60;//当前秒
    NSInteger proSec           = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin           = totalTime / 60;//总秒
    NSInteger durSec           = totalTime % 60;//总分钟
    NSString * str = [NSString stringWithFormat:@"%02zd:%02zd/%02zd:%02zd", proMin, proSec, durMin, durSec];
    if (isForward) {
        self.sliderLabel.text = [NSString stringWithFormat:@">> %@", str];
    }else{
        self.sliderLabel.text = [NSString stringWithFormat:@"<< %@", str];
    }
    if (self.sliderLabel.hidden) {
        self.sliderLabel.hidden = NO;
    }
}

//用户进度调节完毕（滑动调节进度）
- (void)horizontalIsEnd
{
    [SAVORXAPI postUMHandleWithContentId:@"details_page_sliding_progress" key:nil value:nil];
    AVPlayerItem *currentItem = self.player.currentItem;
    NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
    CGFloat totalTime = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
    CGFloat value = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
    [self.controlView setSliderValue:value currentTime:currentTime totalTime:totalTime];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sliderLabel.hidden = YES;
    });
}

//用户手指竖向滑动的时候
- (void)verticalMoved:(CGFloat)value
{
    if (self.isVolume) {
        // 调节音量
        [SAVORXAPI postUMHandleWithContentId:@"details_page_mediation_volume" key:nil value:nil];
        self.volumeViewSlider.value -= value / 10000;
    }else{
        // 调节亮度
        [SAVORXAPI postUMHandleWithContentId:@"details_page_mediation_brightness" key:nil value:nil];
        [UIScreen mainScreen].brightness -= value / 10000;
    }
}

/**
 *  获取系统音量
 */
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            if (self.status != GCCPlayerStatusEnd) {
                [self play];
            }
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            
            break;
    }
}

//变成竖屏
- (void)playOrientationPortrait
{
    self.isFullScreen = NO;
    [self.controlView playOrientationPortrait];
    if ([self viewWithTag:888]) {
        UIView * view = [self viewWithTag:888];
        [view removeFromSuperview];
//        [self play];
    }
}

//变成横屏
- (void)playOrientationLandscape
{
    // 全屏播放
    [SAVORXAPI postUMHandleWithContentId:@"details_page_full_screen" key:nil value:nil];
    [SAVORXAPI postUMHandleWithContentId:@"details_page_rotating_screen" key:nil value:nil];
    self.isFullScreen = YES;
    [self.controlView playOrientationLandscape];
    BOOL temp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasPlay"] boolValue];
    if (!temp) {
            [self createHasNotPlayView];
    }
}

- (void)createHasNotPlayView
{
    [self pause];
    
    UIView * view = [[UIView alloc] init];
    view.tag = 888;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    view.userInteractionEnabled = YES;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"shoushi"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(407, 100));
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notPlayViewClicked)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)notPlayViewClicked
{
    UIView * view = [self viewWithTag:888];
    [view removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"hasPlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self play];
}

#pragma mark -- GCCControlViewDelegate
//截屏按钮被点击
- (void)shotButtonDidClicked
{
    [SAVORXAPI postUMHandleWithContentId:@"details_page_screenshots" key:nil value:nil];
    //判断用户是否拥有权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self shotVideoToPhotoWithCurrentTime:self.player.currentTime];
            }else{
                
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self shotVideoToPhotoWithCurrentTime:self.player.currentTime];
    } else{
        //打开用户应用设置
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:RDLocalizedString(@"RDString_Alert") message:RDLocalizedString(@"RDString_PhotoLibrarySetting") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:RDLocalizedString(@"RDString_Cancle") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:RDLocalizedString(@"RDString_Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [[Helper getRootNavigationController] presentViewController:alert animated:YES completion:nil];
    }
}

//截取某一帧的图片
- (void)shotVideoToPhotoWithCurrentTime:(CMTime)currentTime
{
    CVPixelBufferRef pixelBuffer = [self.playerItemVideoOutput copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage * image = [UIImage imageWithCGImage:videoImage];
    [RDPhotoTool saveImageInSystemPhoto:image withAlert:YES];
    CGImageRelease(videoImage);
}

//用户点击播放按钮以播放视频
- (void)playButtonDidClickedToPlay:(UIButton *)button
{
    [SAVORXAPI postUMHandleWithContentId:@"details_page_play_video" key:nil value:nil];
    [self play];
    if (self.imageView.superview) {
        [self.imageView removeFromSuperview];
    }
}

//用户点击播放按钮以暂停视频
- (void)playButtonDidClickedToPause:(UIButton *)button
{
    [SAVORXAPI postUMHandleWithContentId:@"details_page_pause_button" key:nil value:nil];
    [self pause];
}

//用户拖动进度条调节进度
- (void)sliderDidSlideToTime:(NSInteger)time
{
    [SAVORXAPI postUMHandleWithContentId:@"details_page_drag_progress" key:nil value:nil];
    [self.controlView loading];
    self.isPan = YES;
    [self.player pause];
    if (self.imageView.superview) {
        [self.imageView removeFromSuperview];
    }
    // 转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(time, 1);
    [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
        if (self.status == GCCPlayerStatusPlaying) {
            [self.player play];
        }
        if (self.player.currentItem.playbackLikelyToKeepUp){
            if (self.status == GCCPlayerStatusPlaying) {
                [self.controlView stopLoading];
            }else{
                [self.controlView seekTimeWithPause];
            }
        }
        self.isPan = NO;
    }];
}

//用户点击了左上方的返回键
- (void)backButtonDidClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonDidBeClicked)]) {
        [self.delegate backButtonDidBeClicked];
    }
}

//用户点击了重播按钮
- (void)replayButtonDidClicked
{
    [self play];
//    if (self.isFullScreen) {
//        [self addUserActionForView];
//    }
}

- (void)replayButtonDidClickedWhenFailed
{
    [self setPlayItemWithURL:self.currentURL];
}

- (void)shareButtonDidClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoShouldBeShare)]) {
        [self.delegate videoShouldBeShare];
    }
}

- (void)collectButtonDidClicked:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoShouldBeCollect:)]) {
        [self.delegate videoShouldBeCollect:button];
    }
}

- (void)playItemShouldChangeDefinitionTo:(NSInteger)tag
{
    NSString * url = [self.currentURL substringToIndex:self.currentURL.length - 7];
    url = [NSString stringWithFormat:@"%@f%ld.mp4", url, tag];
    [self setPlayItemWithURL:url];
}

- (void)toolViewStatusHidden:(BOOL)isHidden
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewHiddenStatusDidChangeTo:)]) {
        [self.delegate toolViewHiddenStatusDidChangeTo:isHidden];
    }
}

//app已经进入后台运行
- (void)appDidEnterBackground
{
    self.time = CMTimeMake(self.player.currentTime.value / self.player.currentTime.timescale, 1);
    self.lastStutas = self.status;
    [self pause];
}

//app已经进入前台运行
- (void)appDidEnterPlayground
{
    if (self.lastStutas == GCCPlayerStatusPlaying) {
        [self play];
    }
}

//视频播放
- (void)play
{
    if (self.canPlay) {
        [self.player play];
        self.status = GCCPlayerStatusPlaying;
        [RDLogStatisticsAPI RDItemLogAction:RDLOGACTION_START type:RDLOGTYPE_VIDEO model:self.model categoryID:[NSString stringWithFormat:@"%ld", self.categoryID]];
    }else{
        [self pause];
    }
}

//视频暂停
- (void)pause
{
    [self.player pause];
    if (self.status != GCCPlayerStatusEnd) {
        if (self.status == GCCPlayerStatusPlaying) {
            [RDLogStatisticsAPI RDItemLogAction:RDLOGACTION_END type:RDLOGTYPE_VIDEO model:self.model categoryID:[NSString stringWithFormat:@"%ld", self.categoryID]];
        }
        self.status = GCCPlayerStatusPause;
    }
}

//视频停止
- (void)stop
{
    [self.player pause];
    self.status = GCCPlayerStatusEnd;
    [self sliderDidSlideToTime:0];
    [RDLogStatisticsAPI RDItemLogAction:RDLOGACTION_END type:RDLOGTYPE_VIDEO model:self.model categoryID:[NSString stringWithFormat:@"%ld", self.categoryID]];
}

//set方法，重写以及时获取播放状态并进行不同的处理
- (void)setStatus:(GCCPlayerStatus)status
{
    _status = status;
    switch (status) {
        case GCCPlayerStatusPause:
            [self.controlView pause];
            break;
            
        case GCCPlayerStatusEnd:
        {
            [self.controlView stop];
        }
            break;
            
        case GCCPlayerStatusPlaying:
            [self.controlView play];
            break;
            
        case GCCPlayerStatusInitial:
            
            break;
            
        case GCCPlayerStatusFaild:
        {
            [self playDidBeFaild];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)playDidBeFaild
{
    [self.controlView didPlayFailed];
}

// 重写这个方法，告诉系统，这个View的Layer不是普通的Layer，而是用于播放视频的Layer
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

// AVPlayerLayer 有一个播放器，对播放器的取值和设值，都传递给AVPlayerLayer
- (void)setPlayer:(AVPlayer *)player
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.player = player;
}

- (AVPlayer *)player
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    return playerLayer.player;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (ZFBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [ZFBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}

//- (ZFVolumeView *)volumeView
//{
//    if (!_volumeView) {
//        _volumeView = [ZFVolumeView sharedVolumeView];
//    }
//    return _volumeView;
//}

- (void)shouldRelease
{
    [self.player pause];
    self.delegate = nil;
    self.controlView.delegate = nil;
    // 移除time以及观察者
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    [self.brightnessView removeFromSuperview];
//    [self.volumeView removeFromSuperview];
    NSLog(@"应该释放");
}

- (void)dealloc
{
    [self.controlView cancleWaitToHiddenToolView];
    NSLog(@"播放器释放了");
}

@end
