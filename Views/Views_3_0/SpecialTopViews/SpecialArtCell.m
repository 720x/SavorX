//
//  SpecialArtCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/8/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SpecialArtCell.h"
#import "UIImageView+WebCache.h"

@interface SpecialArtCell ()

@property (nonatomic, copy) NSString * imageURL;

@end

@implementation SpecialArtCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = UIColorFromRGB(0xeee8e0);
    [self addSubview:_bgView];
    CGFloat bgViewHeight = 130 *(802.f/1242.f);
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(bgViewHeight + 10);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130);
        make.height.equalTo(_bgImageView.mas_width).multipliedBy(802.f/1242.f);
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = kPingFangMedium(16);
    _titleLabel.textColor = UIColorFromRGB(0x434343);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"标题";
    self.titleLabel.numberOfLines = 2;
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 130 - 48);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(_bgImageView.mas_right).offset(10);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"";
    _timeLabel.font = kPingFangLight(10);
    _timeLabel.textColor = UIColorFromRGB(0x84827f);
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-5);
        make.left.mas_equalTo(_bgImageView.mas_right).offset(10);
    }];

}

- (void)configModelData:(CreateWealthModel *)model{
    
    CGFloat titleHeight = [self getHeightByWidth:(kMainBoundsWidth - 130 - 48) title:model.title font:kPingFangMedium(16)];
    if (titleHeight > 30) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
    }else{
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
        }];
    }
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.updateTime;
    
    if ([self.imageURL isEqualToString:model.imageURL]) {
        return;
    }
    self.imageURL = model.imageURL;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if ([manager diskImageExistsForURL:[NSURL URLWithString:model.imageURL]]) {
            NSLog(@"不加载动画");
        }else {
            
            self.bgImageView.alpha = 0.0;
            [UIView transitionWithView:self.bgImageView
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                [self.bgImageView setImage:image];
                                self.bgImageView.alpha = 1.0;
                            } completion:NULL];
        }
    }];
    
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

@end
