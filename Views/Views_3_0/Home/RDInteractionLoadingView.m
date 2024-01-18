//
//  RDInteractionLoadingView.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/14.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDInteractionLoadingView.h"

@interface RDInteractionLoadingView ()

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation RDInteractionLoadingView

- (instancetype)initWithView:(UIView *)superView title:(NSString *)title
{
    if (self = [super initWithFrame:superView.bounds]) {
        self.isAnimation = YES;
        [self createLoading];
        
        [superView addSubview:self];
        self.superview.userInteractionEnabled = NO;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self createAnimation];
        self.titleLabel.text = title;
    }
    return self;
}

- (void)hidden
{
    self.isAnimation = NO;
    self.superview.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

- (void)createAnimation
{
    if (self.isAnimation) {
        [UIView animateWithDuration:1 delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.backView.frame = CGRectMake(144.5, 10, .5, 80);
        } completion:^(BOOL finished) {
            self.backView.frame = CGRectMake(20, 10, 125, 80);
            [self createAnimation];
        }];
    }
}

- (void)createLoading
{
    self.backgroundColor = [UIColorFromRGB(0x201a1a) colorWithAlphaComponent:.7f];
    self.userInteractionEnabled = NO;
    
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 165, 114)];
    [backgroundImageView setImage:[UIImage imageNamed:@"ljz_jb"]];
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(backgroundImageView.frame.size);
    }];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 125, 80)];
    self.backView.backgroundColor = VCBackgroundColor;
    [backgroundImageView addSubview:self.backView];
    
    UIImageView * topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 165, 114)];
    [topImageView setImage:[UIImage imageNamed:@"ljz_bg"]];
    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(topImageView.frame.size);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = UIColorFromRGB(0x9a9691);
    self.titleLabel.font = kPingFangRegular(15);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [topImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
}

@end
