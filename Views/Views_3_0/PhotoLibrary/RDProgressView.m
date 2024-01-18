//
//  RDProgressView.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDProgressView.h"

@interface RDProgressView ()

@property(nonatomic ,strong) UILabel *percentageLab;

@end

@implementation RDProgressView

- (instancetype)init
{
    if (self = [super init]) {
        [self customSelf];
    }
    return self;
}

- (void)customSelf
{
    self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    
    self.percentageLab = [[UILabel alloc] init];
    self.percentageLab.font = [UIFont systemFontOfSize:24];
    self.percentageLab.textColor = UIColorFromRGB(0x27e7e3);
    self.percentageLab.backgroundColor = [UIColor clearColor];
    self.percentageLab.textAlignment = NSTextAlignmentCenter;
    self.percentageLab.text = @"0%";
    [self addSubview:self.percentageLab];
    [self.percentageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerY.equalTo(self).offset(-40);
        make.centerX.equalTo(self);
    }];
    
    UILabel *conLabel = [[UILabel alloc] init];
    conLabel.font = [UIFont systemFontOfSize:16];
    conLabel.textColor = UIColorFromRGB(0xffffff);
    conLabel.backgroundColor = [UIColor clearColor];
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.text = [RDLocalizedString(@"RDString_CompressingVideo") stringByAppendingString:@"..."];
    [self addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.percentageLab.mas_bottom).offset(8);
    }];
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:RDLocalizedString(@"RDString_Cancle") forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleButton.layer.cornerRadius = 5;
    cancleButton.layer.masksToBounds = YES;
    cancleButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancleButton.layer.borderWidth = 1.f;
    cancleButton.titleLabel.font = kPingFangLight(15);
    [self addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(28);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(conLabel.mas_bottom).offset(30);
    }];
    [cancleButton addTarget:self action:@selector(cancleButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancleButtonDidClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadVideoDidCancle)]) {
        [self.delegate uploadVideoDidCancle];
    }
}

- (void)setTitle:(NSString *)title
{
    self.percentageLab.text = title;
}

- (void)show
{
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.2f animations:^{
        self.alpha = 1;
    }];
}

- (void)hidden
{
    [self removeFromSuperview];
    self.percentageLab.text = @"0%";
}

@end
