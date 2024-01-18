//
//  SpecialListTableViewCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/8/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SpecialListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SpecialListTableViewCell ()

@property (nonatomic, copy)   NSString * imageURL;
@property (nonatomic, strong) UIView * shadowView;
@property (nonatomic, strong) UIView * bgContentView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;

@end

@implementation SpecialListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.shadowView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.shadowView];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7.5);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-7.5);
        make.right.mas_equalTo(-10);
    }];
    self.shadowView.layer.shadowColor = UIColorFromRGB(0x5e5c58).CGColor;
    self.shadowView.layer.shadowOpacity = .14f;
    self.shadowView.layer.shadowRadius = 7.f;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.backgroundColor = [UIColor clearColor];
    self.bgContentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.shadowView addSubview:self.bgContentView];
    [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.bgContentView.layer.cornerRadius = 4.f;
    self.bgContentView.layer.masksToBounds = YES;
    self.bgContentView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    UIView * topRedView = [[UIView alloc] initWithFrame:CGRectZero];
    topRedView.backgroundColor = UIColorFromRGB(0x902d3f);
    [self.bgContentView addSubview:topRedView];
    [topRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
    }];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = UIColorFromRGB(0x902d3f);
    self.nameLabel.font = kPingFangMedium(18);
    [self.bgContentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.equalTo(topRedView.mas_right).offset(9);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(18);
    }];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    self.bgImageView.backgroundColor = [UIColor clearColor];
    [self.bgContentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.equalTo(self.bgImageView.mas_width).multipliedBy(802.f/1242.f);
    }];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleView.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:.55f];
    [self.bgImageView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = UIColorFromRGB(0xffffff);
    self.titleLabel.font = kPingFangMedium(18);
    self.titleLabel.numberOfLines = 2;
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.textColor = UIColorFromRGB(0x575757);
    self.detailLabel.font = kPingFangLight(15);
    self.detailLabel.numberOfLines = 3;
    [self.bgContentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom).offset(13);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-17);
        make.right.mas_equalTo(-10);
    }];
}

- (void)configWithModel:(CreateWealthModel *)model
{
    self.nameLabel.text = model.name;
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://oss.littlehotspot.com/media/resource/yk7Q67bprb.jpg"]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.desc;
    
    CGFloat width = kMainBoundsWidth - 40 - 24;
    CGFloat height = [self getHeightByWidth:width title:model.title font:kPingFangMedium(18)];
    if (height > 40) {
        height = (kMainBoundsWidth - 40) * (802.f/1242.f) * 0.232 + 25;
    }else{
        height = (kMainBoundsWidth - 40) * (802.f/1242.f) * 0.232;
    }
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    if ([self.imageURL isEqualToString:model.img_url]) {
        return;
    }
    self.imageURL = model.img_url;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
