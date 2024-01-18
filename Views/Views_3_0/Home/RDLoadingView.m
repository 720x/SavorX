//
//  RDLoadingView.m
//  小热点3.0
//
//  Created by 郭春城 on 2017/7/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDLoadingView.h"

@interface RDLoadingView ()

@property (nonatomic, strong) UIImageView * animationImageView;

@end

@implementation RDLoadingView

- (instancetype)init
{
    if (self = [super init]) {
        [self createLoadingView];
    }
    return self;
}

- (void)showLoaingAnimation
{
    if (self.animationImageView.isAnimating) {
        [self.animationImageView stopAnimating];
    }
    [self.animationImageView setImage:[UIImage imageNamed:@"jiazai4"]];
    self.animationImageView.animationImages = @[[UIImage imageNamed:@"jiazai1"],
                                                [UIImage imageNamed:@"jiazai2"],
                                                [UIImage imageNamed:@"jiazai3"]];
    self.animationImageView.animationDuration = 0.6f;
    self.animationImageView.animationRepeatCount = 1;
    [self.animationImageView startAnimating];
    [self performSelector:@selector(secondAnimation) withObject:nil afterDelay:1.1];
}

- (void)secondAnimation
{
    [self.animationImageView setImage:[UIImage imageNamed:@"jiazai8"]];
    self.animationImageView.animationImages = @[[UIImage imageNamed:@"jiazai5"],
                                                [UIImage imageNamed:@"jiazai6"],
                                                [UIImage imageNamed:@"jiazai7"]];
    self.animationImageView.animationDuration = 0.3f;
    self.animationImageView.animationRepeatCount = 1;
    [self.animationImageView startAnimating];
    [self performSelector:@selector(showLoaingAnimation) withObject:nil afterDelay:.4];
}

- (void)hiddenLoaingAnimation
{
    if (self.animationImageView.isAnimating) {
        [self.animationImageView stopAnimating];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoaingAnimation) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(secondAnimation) object:nil];
    [self removeFromSuperview];
}

- (void)createLoadingView
{
    self.animationImageView = [[UIImageView alloc] init];
    self.animationImageView.userInteractionEnabled = YES;
    [self addSubview:self.animationImageView];
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView setImage:[UIImage imageNamed:@"jiazai_slogan"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
}

@end
