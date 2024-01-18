//
//  HeadlinesSTopTableViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/7/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HeadlinesSTopTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface HeadlinesSTopTableViewCell ()

@property (nonatomic, copy) NSString * imageURL;

@end

@implementation HeadlinesSTopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self.contentView addSubview:_bgView];
    CGFloat bgHeight =(kMainBoundsWidth - 30) *802.f/1242.f + 113;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bgHeight);//335.5
        make.width.mas_equalTo(kMainBoundsWidth - 20);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 222.5));//222.5
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.equalTo(_bgImageView.mas_width).multipliedBy(802.f/1242.f);//222.5
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = kPingFangMedium(17);
    _titleLabel.textColor = UIColorFromRGB(0x434343);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"标题";
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
    }];
        
    _subTitleLabel = [[UILabel alloc]init];
    _subTitleLabel.text = @"";
    _subTitleLabel.font = kPingFangLight(14);
    _subTitleLabel.textColor = UIColorFromRGB(0x575759);
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    _subTitleLabel.numberOfLines = 2;
    [_bgView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"";
    _timeLabel.font = kPingFangLight(10);
    _timeLabel.textColor = UIColorFromRGB(0xb2afab);
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 10));
        make.bottom.mas_equalTo(self).offset(- 16);
        make.left.mas_equalTo(10);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xece6de);
    [_bgView addSubview:lineView];
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 20, 6));
        make.top.mas_equalTo(_bgView.mas_bottom).offset(-6);
        make.left.mas_equalTo(0);
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

- (void)configModelData:(CreateWealthModel *)model{
    
    CGFloat subTitleHeight = [self getHeightByWidth:kMainBoundsWidth - 30 title:model.shareTitle font:kPingFangMedium(14)];
    if (subTitleHeight > 20) {
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 40));
        }];
        //当副标题为两行时，背景加20
        CGFloat bgHeight =(kMainBoundsWidth - 30) *802.f/1242.f + 133;
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bgHeight);
        }];
    }else{
        
        [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
        }];
        
        CGFloat bgHeight =(kMainBoundsWidth - 30) *802.f/1242.f + 113;
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bgHeight);
        }];
    }
    
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.shareTitle;
    
    self.timeLabel.text = model.updateTime;
    if (!isEmptyString(model.updateTime)) {
        self.timeLabel.text =  [model.updateTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    }
    
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
