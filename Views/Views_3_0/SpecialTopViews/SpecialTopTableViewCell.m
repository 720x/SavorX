//
//  SpecialTopTableViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/7/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SpecialTopTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SpecialTopTableViewCell ()

@property (nonatomic, copy) NSString * imageURL;

@end

@implementation SpecialTopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130);
        make.height.equalTo(_bgImageView.mas_width).multipliedBy(802.f/1242.f);//84
        make.top.mas_equalTo(4.5);
        make.right.mas_equalTo(-15);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = kPingFangMedium(16);
    _titleLabel.textColor = UIColorFromRGB(0x434343);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"标题";
    self.titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    CGFloat titleWidth = kMainBoundsWidth - 30 - 130 - 10;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:titleWidth], 25));
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(15);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"";
    _timeLabel.font = kPingFangLight(10);
    _timeLabel.textColor = UIColorFromRGB(0xb2afab);
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-12);
        make.left.mas_equalTo(15);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xe0dad2);
    [self addSubview:lineView];
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 1));
        make.bottom.mas_equalTo(self.bottom).offset(-1);
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
    
    CGFloat titleWidth = kMainBoundsWidth - 30 - 130 - 8;
    if (kMainBoundsHeight == 568) {
        titleWidth = kMainBoundsWidth - 30 - 130 - 8;
    }
    CGFloat titleHeight = [self getHeightByWidth:titleWidth title:model.title font:kPingFangMedium(16)];
    if (titleHeight > 30) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(titleWidth, 50));
        }];
    }else{
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(titleWidth, 25));
        }];
    }
    self.titleLabel.text = model.title;
    
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
