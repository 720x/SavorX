//
//  GCCPlayerView.h
//  RDPlayer
//
//  Created by 郭春城 on 16/10/17.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"

@protocol GCCPlayerViewDelegate <NSObject>

@optional
- (void)backButtonDidBeClicked;
- (void)videoShouldBeShare;
- (void)videoShouldBeCollect:(UIButton *)button;
- (void)videoShouldBeDemand;
- (void)toolViewHiddenStatusDidChangeTo:(BOOL)isHidden;

@end

@interface GCCPlayerView : UIView

- (instancetype)initWithURL:(NSString *)url;

@property (nonatomic, assign) id<GCCPlayerViewDelegate> delegate;
@property (nonatomic, strong) CreateWealthModel * model;
@property (nonatomic, assign) NSInteger categoryID; //分类ID


- (void)play; //开始播放
- (void)pause; //暂停播放
- (void)setPlayItemWithURL:(NSString *)url; //设置播放URL
- (void)setVideoTitle:(NSString *)title; //设置播放标题
- (void)setIsCollect:(BOOL)isCollect; //设置是否收藏
- (void)playOrientationLandscape; //横屏切换
- (void)playOrientationPortrait; //竖屏切换

- (void)backgroundImage:(NSString *)url;

- (void)shouldRelease;

- (void)setCollectEnable:(BOOL)enable;

@end
