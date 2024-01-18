//
//  RD_MJRefreshHeader.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RD_MJRefreshHeader.h"

@interface RD_MJRefreshHeader ()

//@property (assign, nonatomic) CGFloat insetTDelta;

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIImageView * animationImageView;

@end

@implementation RD_MJRefreshHeader

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.topView];
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
    [self.animationImageView setImage:[UIImage imageNamed:@"jiazai1"]];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 当前的contentOffset
    CGFloat offsetY = -self.scrollView.mj_offsetY;
    CGFloat centerY = MJRefreshHeaderHeight / 2;
    CGFloat scale = 1.f;
    if (offsetY <= 54) {
        scale = offsetY / 54.f;
        centerY = MJRefreshHeaderHeight - centerY * (scale);
    }
    self.topView.center = CGPointMake(kMainBoundsWidth/2, centerY);
    self.topView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState != MJRefreshStateRefreshing) return;
        
        [self hiddenLoaingAnimation];
        
    } else if (state == MJRefreshStateRefreshing) {
        
        [self showLoaingAnimation];
        
    }
}

//#pragma mark - 公共方法
//- (void)endRefreshing
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.state = MJRefreshStateIdle;
//    });
//}

//- (NSDate *)lastUpdatedTime
//{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
//}

- (UIView *)topView
{
    if (!_topView) {
        CGRect frame = self.frame;
//        frame.size.height = 30;
        frame.size.width = kMainBoundsWidth;
        frame.size.height = MJRefreshHeaderHeight;
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 26)];
        _topView.center = CGPointMake(kMainBoundsWidth / 2, MJRefreshHeaderHeight / 2);
        [self addSubview:_topView];
        
        self.animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _topView.frame.size.width, 15)];
        [self.animationImageView setImage:[UIImage imageNamed:@"jiazai1"]];
        self.animationImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_topView addSubview:self.animationImageView];
        
        UIImageView * slogan = [[UIImageView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height - 7, _topView.frame.size.width, 7)];
        [slogan setImage:[UIImage imageNamed:@"jiazai_slogan"]];
        slogan.contentMode = UIViewContentModeScaleAspectFit;
        [_topView addSubview:slogan];
    }
    return _topView;
}

@end
