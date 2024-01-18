//
//  RDDemandTableViewCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/8/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDDemandTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface RDDemandTableViewCell ()

@property (nonatomic, strong) CreateWealthModel * model;

@property (nonatomic, strong) UIImageView * baseImageView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailFrom;
@property (nonatomic, strong) UILabel * detailDate;
@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation RDDemandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * shadowView = [[UIView alloc] init];
    [self.contentView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    shadowView.layer.shadowColor = UIColorFromRGB(0x8f8577).CGColor;
    shadowView.layer.shadowOpacity = .3f;
    shadowView.layer.shadowRadius = 5;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIView * baseView = [[UIView alloc] init];
    [shadowView addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    baseView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    baseView.layer.cornerRadius = 5;
    baseView.layer.masksToBounds = YES;
    
    self.baseImageView = [[UIImageView alloc] init];
    self.baseImageView.backgroundColor = [UIColor blackColor];
    self.baseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.baseImageView.clipsToBounds = YES;
    self.baseImageView.userInteractionEnabled = YES;
    [baseView addSubview:self.baseImageView];
    [self.baseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.baseImageView.mas_width).multipliedBy(.646);
    }];
    
    CGSize viewSize = CGSizeMake(140 * scale, 120 * scale);
    CGSize buttonSize = CGSizeMake(90 * scale, 27 * scale);
    
    UIView * leftView = [[UIView alloc] init];
    leftView.tag = 101;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidBeClicked:)];
    tap.numberOfTapsRequired = YES;
    [leftView addGestureRecognizer:tap];
    leftView.exclusiveTouch = YES;
    [self.baseImageView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-80 * scale);
        make.centerY.mas_equalTo(20 * scale);
        make.size.mas_equalTo(viewSize);
    }];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"sjbf"] forState:UIControlStateNormal];
    leftButton.userInteractionEnabled = NO;
    [leftView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(20 * scale);
        make.centerY.mas_equalTo(-20 * scale);
        make.size.mas_equalTo(buttonSize);
    }];
    
    UIView * rightView = [[UIView alloc] init];
    rightView.tag = 102;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidBeClicked:)];
    tap2.numberOfTapsRequired = YES;
    [rightView addGestureRecognizer:tap2];
    rightView.exclusiveTouch = YES;
    [self.baseImageView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(80 * scale);
        make.centerY.mas_equalTo(20 * scale);
        make.size.mas_equalTo(viewSize);
    }];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"dsbf"] forState:UIControlStateNormal];
    rightButton.userInteractionEnabled = NO;
    [rightView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-20 * scale);
        make.centerY.mas_equalTo(-20 * scale);
        make.size.mas_equalTo(buttonSize);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = kPingFangLight(11);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [self.baseImageView addSubview:self.timeLabel];
    self.timeLabel.layer.cornerRadius = 9;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.borderColor = UIColorFromRGB(0x4f4d49).CGColor;
    self.timeLabel.layer.borderWidth = .5f;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 18));
        make.bottom.right.mas_equalTo(-5);
    }];
    
    self.bottomView = [[UIView alloc] init];
    [baseView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseImageView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = kPingFangMedium(16);
    self.titleLabel.textColor = UIColorFromRGB(0x434343);
    [self.bottomView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
    }];
    
    self.detailFrom = [[UILabel alloc] init];
    self.detailFrom.font = kPingFangLight(12);
    self.detailFrom.textColor = UIColorFromRGB(0x898886);
    [self.bottomView addSubview:self.detailFrom];
    [self.detailFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(12);
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    self.detailDate = [[UILabel alloc] init];
    self.detailDate.font = kPingFangLight(10);
    self.detailDate.textColor = UIColorFromRGB(0xb2afab);
    [self.bottomView addSubview:self.detailDate];
    [self.detailDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailFrom.mas_right).offset(10);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(12);
        make.width.lessThanOrEqualTo(@(100));
    }];
}

- (void)configWithInfo:(CreateWealthModel *)model
{
    self.model = model;
    [self.baseImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if ([manager diskImageExistsForURL:[NSURL URLWithString:self.model.imageURL]]) {
            NSLog(@"不加载动画");
        }else {
            
            self.baseImageView.alpha = 0.0;
            [UIView transitionWithView:self.baseImageView
                              duration:0.15f
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                [self.baseImageView setImage:image];
                                self.baseImageView.alpha = 1.0;
                            } completion:NULL];
        }
    }];
    self.titleLabel.text = self.model.title;
    self.detailFrom.text = self.model.sourceName;
    self.detailDate.text = self.model.updateTime;
    
    if (!isEmptyString(self.detailFrom.text)) {
        [self.detailDate mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailFrom.mas_right).offset(10);
        }];
    }else{
        [self.detailDate mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailFrom.mas_right).offset(0);
        }];
    }
    
    long long minute = 0, second = 0;
    second = self.model.duration;
    minute = second / 60;
    second = second % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2lld'%.2lld\"", minute, second];
}

- (void)buttonDidBeClicked:(UITapGestureRecognizer *)tap
{
    if (self.clickHandel) {
        if (tap.view.tag == 101) {
            self.clickHandel(YES, self.model);
        }else{
            self.clickHandel(NO, self.model);
        }
    }
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
