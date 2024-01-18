//
//  RDFavoriteTableViewCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDFavoriteTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface RDFavoriteTableViewCell ()

@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * fromLabel;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UILabel * imageLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation RDFavoriteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.leftImageView = [[UIImageView alloc] init];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-6);
        make.width.equalTo(self.leftImageView.mas_height).multipliedBy(130.f/84.f);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kPingFangMedium(16);
    self.titleLabel.textColor = UIColorFromRGB(0x434343);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(-40);
        make.right.mas_equalTo(-15);
    }];
    
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.font = kPingFangLight(11);
    self.fromLabel.textColor = UIColorFromRGB(0x8a8886);
    [self.contentView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = kPingFangLight(10);
    self.dateLabel.textColor = UIColorFromRGB(0xb2afab);
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fromLabel.mas_right).offset(10);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    self.imageLabel = [[UILabel alloc] init];
    self.imageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    self.imageLabel.textColor = [UIColor whiteColor];
    self.imageLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftImageView addSubview:self.imageLabel];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = UIColorFromRGB(0xe0dad2);
    [self addSubview:self.lineView];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 1));
        make.bottom.mas_equalTo(self.bottom).offset(-1);
        make.left.mas_equalTo(0);
    }];
    self.lineView.hidden = YES;
}

- (void)configWithModel:(CreateWealthModel *)model
{
    if (self.imageLabel.superview) {
        [self.imageLabel removeFromSuperview];
    }
    
    if (!isEmptyString(model.sourceName)) {
        [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fromLabel.mas_right).offset(10);
        }];
    }else{
        [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fromLabel.mas_right).offset(0);
        }];
    }
    self.titleLabel.text = model.title;
    self.fromLabel.text = model.sourceName;
    self.dateLabel.text = model.acreateTime;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if ([manager diskImageExistsForURL:[NSURL URLWithString:model.imageURL]]) {
            NSLog(@"不加载动画");
        }else {
            
            self.leftImageView.alpha = 0.0;
            [UIView transitionWithView:self.leftImageView
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                [self.leftImageView setImage:image];
                                self.leftImageView.alpha = 1.0;
                            } completion:NULL];
        }
    }];
    
    if (model.type == 2) {
        
        if (!self.imageLabel.superview) {
            [self.leftImageView addSubview:self.imageLabel];
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
            [self.leftImageView addSubview:self.imageLabel];
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

- (void)reConfigWithTimeStr:(NSString *)timeStr{
    self.dateLabel.text = timeStr;
}

//- (void)reloadWithUcreateTime:(NSString *)ucreateTime
//{
//    self.dateLabel.text = [Helper transformDate:[NSDate dateWithTimeIntervalSince1970:[ucreateTime doubleValue]]];
//}

- (void)setLineViewHidden:(BOOL)hidden
{
    self.lineView.hidden = hidden;
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
