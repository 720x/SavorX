//
//  VideoTableViewCell.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/7/3.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface VideoTableViewCell ()

@property (nonatomic, copy) NSString * imageURL;

@end

@implementation VideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    
//    _bgView = [[UIView alloc]init];
//    _bgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
//    [self.contentView addSubview:_bgView];
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 285));
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = kPingFangMedium(16);
    _titleLabel.textColor = UIColorFromRGB(0x434343);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"标题";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
    }];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30);//190
        make.height.equalTo(_bgImageView.mas_width).multipliedBy(802.f/1242.f);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    
    _videoPauseImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _videoPauseImage.contentMode = UIViewContentModeScaleAspectFill;
    _videoPauseImage.layer.masksToBounds = YES;
    _videoPauseImage.backgroundColor = [UIColor clearColor];
    _videoPauseImage.image = [UIImage imageNamed:@"sp_zanting"];
    [_bgImageView addSubview:_videoPauseImage];
    [_videoPauseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.center.mas_equalTo(_bgImageView.center);
    }];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.text = @"4\'23\"";
    _countLabel.font = kPingFangLight(14);
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:.5f];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.layer.cornerRadius = 10;
    _countLabel.layer.masksToBounds = YES;
    [_bgImageView addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-10);
        make.right.mas_equalTo(_bgImageView.mas_right).offset(-10);
    }];
    
    _sourceImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _sourceImage.contentMode = UIViewContentModeScaleAspectFill;
    _sourceImage.layer.masksToBounds = YES;
    _sourceImage.backgroundColor = [UIColor clearColor];
    _sourceImage.layer.cornerRadius = 20/2;//裁成圆角
    _sourceImage.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    [self addSubview:_sourceImage];
    [_sourceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
    }];
    
    _sourceLabel = [[UILabel alloc]init];
    _sourceLabel.text = @"";
    _sourceLabel.font = [UIFont systemFontOfSize:11];
    _sourceLabel.textColor = UIColorFromRGB(0x8a8886);
    [self addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(100);
        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(_sourceImage.mas_right).offset(6);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"";
    _timeLabel.font = kPingFangLight(10);
    _timeLabel.textColor = UIColorFromRGB(0xb2afab);
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(_sourceLabel.mas_right).offset(10.5);
    }];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = UIColorFromRGB(0xe0dad2);
    [self addSubview:_lineView];
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 1));
        make.bottom.mas_equalTo(self.bottom).offset(-1);
        make.left.mas_equalTo(0);
    }];
    
    
}

- (void)configModelData:(CreateWealthModel *)model{
    
    self.titleLabel.text = model.title;
    self.sourceLabel.text = model.sourceName;
    self.timeLabel.text =  model.updateTime;
                            
    long long minute = 0, second = 0;
    second = model.duration;
    minute = second / 60;
    second = second % 60;
    self.countLabel.text = [NSString stringWithFormat:@"%lld'%.2lld\"", minute, second];
    
    if ([self.imageURL isEqualToString:model.imageURL]) {
        return;
    }
    self.imageURL = model.imageURL;
    
    [self.sourceImage sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"zanwu"]];
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
