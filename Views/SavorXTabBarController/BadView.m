//
//  BadView.m
//  SavorX
//
//  Created by 郭春城 on 16/9/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "BadView.h"

@implementation BadView

- (instancetype)initBadNetWorkView
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)]) {
        [self createBadNetWorkView];
    }
    return self;
}

- (instancetype)initBadServerView
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)]) {
        [self createBadServerView];
    }
    return self;
}

//创建网络不给力提示
- (void)createBadNetWorkView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 170)];
    view.center = CGPointMake(kScreen_Width / 2, (kScreen_Height - 64) / 2);
    [self addSubview:view];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 52)];
    [imageView setImage:[UIImage imageNamed:@"bad"]];
    imageView.center = CGPointMake(self.frame.size.width / 2, 52);
    [view addSubview:imageView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.frame.size.width, 40)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"为何网络如此不给力?\n点点都找不到它了~";
    [view addSubview:titleLabel];
    
    UILabel * refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, self.frame.size.width, 20)];
    refreshLabel.textColor = [UIColor grayColor];
    refreshLabel.font = [UIFont systemFontOfSize:12];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.text = @"点击屏幕刷新一下";
    [view addSubview:refreshLabel];
    [self addGestureForBadView];
}

// 创建服务器问题提示
- (void)createBadServerView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
    view.center = CGPointMake(kScreen_Width / 2, (kScreen_Height - 64) / 2);
    [self addSubview:view];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 52)];
    [imageView setImage:[UIImage imageNamed:@"bad"]];
    imageView.center = CGPointMake(self.frame.size.width / 2, 52);
    [view addSubview:imageView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.frame.size.width, 20)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"小点儿抢修中...";
    [view addSubview:titleLabel];
    
    UILabel * refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.frame.size.width, 20)];
    refreshLabel.textColor = [UIColor grayColor];
    refreshLabel.font = [UIFont systemFontOfSize:12];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.text = @"点击屏幕刷新一下";
    [view addSubview:refreshLabel];
    [self addGestureForBadView];
}

//添加点击手势
- (void)addGestureForBadView
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidClicked)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)buttonDidClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(BadViewDidBeClicked:)]) {
        [_delegate BadViewDidBeClicked:self];
    }
}

@end
