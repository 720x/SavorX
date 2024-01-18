//
//  ZFVolumeView.m
//  SavorX
//
//  Created by 郭春城 on 17/3/9.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ZFVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZFVolumeView ()

@property (nonatomic, strong) UIImageView		*backImage;
@property (nonatomic, strong) UILabel			*title;
@property (nonatomic, strong) UIView			*longView;
@property (nonatomic, strong) NSMutableArray	*tipArray;
@property (nonatomic, assign) BOOL				orientationDidChange;
@property (nonatomic, strong) UILabel           *detailLabel;

@end

@implementation ZFVolumeView

+ (instancetype)sharedVolumeView {
    static ZFVolumeView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZFVolumeView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:instance];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.5, [[UIScreen mainScreen] bounds].size.height * 0.5, 155, 155);
        
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        
        // 使用UIToolbar实现毛玻璃效果，简单粗暴，支持iOS7+
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.alpha = 0.95;
        [self addSubview:toolbar];
        
        self.backImage = ({
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 76)];
            imgView.image        = [UIImage imageNamed:@"ZFVolume"];
            [self addSubview:imgView];
            imgView;
        });
        
        self.title = ({
            UILabel *title      = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
            title.font          = [UIFont boldSystemFontOfSize:16];
            title.textColor     = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
            title.textAlignment = NSTextAlignmentCenter;
            title.text          = @"音量";
            [self addSubview:title];
            title;
        });
        
        self.detailLabel = ({
            UILabel *title      = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 37, self.bounds.size.width, 30)];
            title.font          = [UIFont systemFontOfSize:15];
            title.textColor     = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.f];
            title.textAlignment = NSTextAlignmentCenter;
            title.text          = @"静音";
            [self addSubview:title];
            title;
        });
        
        self.longView = ({
            UIView *longView         = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
            longView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
            [self addSubview:longView];
            longView;
        });
        
        [self createTips];
        [self addNotification];
        
        self.alpha = 0.0;
    }
    return self;
}

// 创建 Tips
- (void)createTips {
    
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    
    CGFloat tipW = (self.longView.bounds.size.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX          = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
        [self.longView addSubview:image];
        [self.tipArray addObject:image];
    }
    [self updateLongView:[UIScreen mainScreen].brightness];
}

#pragma makr - 通知 KVO

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLayer:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemVolumeDidChange:) name:
     @"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

- (void)systemVolumeDidChange:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self changeVolume:volume];
}

- (void)changeVolume:(CGFloat)sound
{
    [self appearSoundView];
    [self updateLongView:sound];
}

- (void)updateLayer:(NSNotification *)notify {
    self.orientationDidChange = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Methond

- (void)appearSoundView {
    if (self.alpha == 0.0) {
        self.orientationDidChange = NO;
        self.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self disAppearSoundView];
        });
    }
}

- (void)disAppearSoundView {
    
    if (self.alpha == 1.0) {
        [UIView animateWithDuration:0.8 animations:^{
            self.alpha = 0.0;
        }];
    }
}

#pragma mark - Update View

- (void)updateLongView:(CGFloat)sound {
    CGFloat stage = 1 / 15.0;
    NSInteger level = sound / stage;
    
    if (level == 0) {
        [self volumeDidBeClose];
    }else{
        [self volumeDidBeOpen];
    }
    
    for (int i = 0; i < self.tipArray.count; i++) {
        UIImageView *img = self.tipArray[i];
        
        if (i < level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}

- (void)volumeDidBeClose
{
    self.longView.alpha = 0;
    self.detailLabel.alpha = 1.f;
    self.backImage.image = [UIImage imageNamed:@"voiceClose"];
}

- (void)volumeDidBeOpen
{
    self.longView.alpha = 1.f;
    self.detailLabel.alpha = 0.f;
    self.backImage.image = [UIImage imageNamed:@"ZFVolume"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backImage.center = CGPointMake(155 * 0.5, 155 * 0.5);
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

@end
