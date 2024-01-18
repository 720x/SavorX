//
//  CreatWealthDetialTableViewCell.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/7/4.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "CreatWealthDetialTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CreatWealthDetialTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:238/255.0 alpha:1.0];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 140));
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
    }];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.backgroundColor = [UIColor blueColor];
    [_bgView addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width/3 + 10, 140));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"餐厅名";
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width/3 *2, 30));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_bgImageView.mas_right).offset(10);
    }];
    
    _sourceImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _sourceImage.contentMode = UIViewContentModeScaleAspectFill;
    _sourceImage.layer.masksToBounds = YES;
    _sourceImage.backgroundColor = [UIColor orangeColor];
    [_bgView addSubview:_sourceImage];
    [_sourceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.mas_equalTo(_bgImageView.mas_bottom).offset(-10);
        make.left.mas_equalTo(_bgImageView.mas_right).offset(10);
    }];
    
    _sourceLabel = [[UILabel alloc]init];
    _sourceLabel.text = @"";
    _sourceLabel.font = [UIFont systemFontOfSize:14];
    _sourceLabel.textColor = [UIColor blackColor];
    [_bgView addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 15));
        make.top.mas_equalTo(_sourceImage.mas_top);
        make.left.mas_equalTo(_sourceImage.mas_right).offset(5);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor blackColor];
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.top.mas_equalTo(_sourceLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_sourceImage.mas_right).offset(5);
    }];
}

- (void)configModelData:(CreateWealthModel *)model{
    
    self.titleLabel.text = model.title;
    self.sourceLabel.text = model.sourceName;
    if (!isEmptyString(model.updateTime)) {
        self.timeLabel.text =  [model.updateTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    }
//    self.sourceImage = [UIImage imageNamed:model.logo];
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
