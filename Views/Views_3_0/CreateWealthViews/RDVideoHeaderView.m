//
//  RDVideoHeaderView.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDVideoHeaderView.h"
#import "UIImageView+WebCache.h"

@interface RDVideoHeaderView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * fromLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * recommandLabel;

@end

@implementation RDVideoHeaderView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 135)]) {
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kPingFangMedium(20);
    self.titleLabel.textColor = UIColorFromRGB(0x434343);
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.layer.cornerRadius = 22.5/2;//裁成圆角
    self.logoImageView.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    [self addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(22.5);
        make.height.mas_equalTo(22.5);
    }];
    
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.font = kPingFangLight(11);
    self.fromLabel.textColor = UIColorFromRGB(0x898886);
    [self addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
        make.left.equalTo(self.logoImageView.mas_right).offset(6);
        make.height.mas_equalTo(12);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = kPingFangLight(10);
    self.timeLabel.textColor = UIColorFromRGB(0xb2afab);
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(18.5);
        make.left.equalTo(self.fromLabel.mas_right).offset(10);
        make.height.mas_equalTo(11);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    self.recommandLabel = [[UILabel alloc] init];
    self.recommandLabel.font = kPingFangRegular(15);
    self.recommandLabel.textColor = UIColorFromRGB(0x922c3e);
    self.recommandLabel.text = RDLocalizedString(@"RDString_RecommendForYou");
    [self addSubview:self.recommandLabel];
    [self.recommandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xece6de);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.equalTo(self.recommandLabel.mas_top).offset(-16);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(8);
    }];
}

- (void)needRecommand:(BOOL)recommand
{
    if (recommand) {
        self.recommandLabel.hidden = NO;
    }else{
        self.recommandLabel.hidden = YES;
    }
}

- (void)reloadWithModel:(CreateWealthModel *)model
{
    self.titleLabel.text = model.title;
    
    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30, 150) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    if (rect.size.height > 40) {
        CGRect frame = self.frame;
        frame.size.height = 170;
        self.frame = frame;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
    }else{
        CGRect frame = self.frame;
        frame.size.height = 135;
        self.frame = frame;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
    }
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    if (isEmptyString(model.logo)) {
        [self.fromLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
            make.left.equalTo(self.logoImageView.mas_left).offset(0);
            make.height.mas_equalTo(12);
            make.width.mas_lessThanOrEqualTo(100);
        }];
    }else{
        [self.fromLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
            make.left.equalTo(self.logoImageView.mas_right).offset(6);
            make.height.mas_equalTo(12);
            make.width.mas_lessThanOrEqualTo(100);
        }];
    }
    
    self.fromLabel.text = model.sourceName;
    if (isEmptyString(model.sourceName)) {
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(18.5);
            make.left.equalTo(self.fromLabel.mas_left).offset(0);
            make.height.mas_equalTo(11);
            make.width.mas_lessThanOrEqualTo(100);
        }];
    }else{
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(18.5);
            make.left.equalTo(self.fromLabel.mas_right).offset(10);
            make.height.mas_equalTo(11);
            make.width.mas_lessThanOrEqualTo(100);
        }];
    }
    
    self.timeLabel.text = model.updateTime;
    
    [self needRecommand:NO];
}

@end
