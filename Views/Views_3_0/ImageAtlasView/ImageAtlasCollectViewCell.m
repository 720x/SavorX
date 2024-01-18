//
//  ImageAtlasCollectViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/8/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ImageAtlasCollectViewCell.h"
#import "UIImageView+WebCache.h"

@interface ImageAtlasCollectViewCell()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel * imageLabel;

@end

@implementation ImageAtlasCollectViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-52);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = kPingFangRegular(15);
    _titleLabel.textColor = UIColorFromRGB(0x434343);
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"这是标题";
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(42);
        make.top.equalTo(_bgImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(10);
    }];
    
    self.imageLabel = [[UILabel alloc] init];
    self.imageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    self.imageLabel.textColor = [UIColor whiteColor];
    self.imageLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.imageLabel];
}

- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (void)configModelData:(CreateWealthModel *)model andIsPortrait:(BOOL)isPortrait{
    // 如果是横屏
    if (isPortrait == NO) {
        
        _titleLabel.numberOfLines = 1;
        [_bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-31);
        }];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
        }];
    }else{
        
        _titleLabel.numberOfLines = 0;
        [_bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-52);
        }];
        
        CGFloat height = [self getHeightByWidth:(kMainBoundsWidth - 5) / 2 - 30 title:model.title font:kPingFangRegular(15)];
        if (height > 21) {
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(42);
            }];
        }else{
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(21);
            }];
        }
    }
    
    self.titleLabel.text = model.title;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    
    if (model.type == 2) {
        
        if (!self.imageLabel.superview) {
            [self.bgImageView addSubview:self.imageLabel];
        }
        self.imageLabel.layer.masksToBounds = NO;
        self.imageLabel.font = kPingFangLight(10);
        [self.imageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(14);
            make.width.mas_greaterThanOrEqualTo(25);
            make.width.mas_lessThanOrEqualTo(50);
        }];
        self.imageLabel.text = [NSString stringWithFormat:@"%@%@", model.colTuJi, RDLocalizedString(@"RDString_Image")];
        
    }else if (model.type == 3 || model.type == 4) {
        
        if (!self.imageLabel.superview) {
            [self.bgImageView addSubview:self.imageLabel];
        }
        self.imageLabel.layer.masksToBounds = YES;
        self.imageLabel.font = kPingFangLight(11);
        [self.imageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(16);
            make.width.mas_greaterThanOrEqualTo(35);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        
        long long minute = 0, second = 0;
        second = model.duration;
        minute = second / 60;
        second = second % 60;
        self.imageLabel.text = [NSString stringWithFormat:@"%lld'%.2lld\"", minute, second];
        
        self.imageLabel.layer.cornerRadius = 8;
        self.imageLabel.layer.masksToBounds = YES;
        
    }else{
        [self.imageLabel removeFromSuperview];
    }
    
}

@end
