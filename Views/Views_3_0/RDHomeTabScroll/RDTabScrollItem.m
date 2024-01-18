//
//  RDTabScrollItem.m
//  小热点切换
//
//  Created by 郭春城 on 2017/6/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDTabScrollItem.h"
#import "RDTabScrollViewPage.h"
#import "UIImageView+WebCache.h"

@interface RDTabScrollItem ()

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailFrom;
@property (nonatomic, strong) UILabel * detailDate;
@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) RDTabScrollViewPage * page;

@property (nonatomic, strong) CreateWealthModel * model;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, assign) NSInteger total;

@end

@implementation RDTabScrollItem

- (instancetype)initWithFrame:(CGRect)frame info:(CreateWealthModel *)model index:(NSInteger)index total:(NSInteger)total
{
    if (self = [super initWithFrame:frame]) {
        
        self.index = index;
        self.model = model;
        self.total = total;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            if ([manager diskImageExistsForURL:[NSURL URLWithString:self.model.imageURL]]) {
                NSLog(@"不加载动画");
            }else {
                
                self.imageView.alpha = 0.0;
                [UIView transitionWithView:self.imageView
                                  duration:1.0f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    [self.imageView setImage:image];
                                    self.imageView.alpha = 1.0;
                                } completion:NULL];
            }
        }];
        [self createSubViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.imageView setImage:[UIImage new]];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.layer.shadowColor = UIColorFromRGB(0x8f8577).CGColor;
    self.layer.shadowOpacity = .2f;
    self.layer.shadowRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    CGSize imageViewSize = self.imageView.frame.size;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 120)];
    leftView.center = CGPointMake(imageViewSize.width / 2 - 80, imageViewSize.height / 2 + 20);
    leftView.tag = 101;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidBeClicked:)];
    tap.numberOfTapsRequired = YES;
    [leftView addGestureRecognizer:tap];
    leftView.exclusiveTouch = YES;
    [self.baseView addSubview:leftView];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 90, 27);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"sjbf"] forState:UIControlStateNormal];
    leftButton.center = CGPointMake(leftView.frame.size.width / 2 + 20, leftView.frame.size.height / 2 - 20);
    leftButton.userInteractionEnabled = NO;
    [leftView addSubview:leftButton];
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 120)];
    rightView.center = CGPointMake(imageViewSize.width / 2 + 80, imageViewSize.height / 2 + 20);
    rightView.tag = 102;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidBeClicked:)];
    tap2.numberOfTapsRequired = YES;
    [rightView addGestureRecognizer:tap2];
    rightView.exclusiveTouch = YES;
    [self.baseView addSubview:rightView];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 90, 27);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"dsbf"] forState:UIControlStateNormal];
    rightButton.center = CGPointMake(rightView.frame.size.width / 2 - 20, rightView.frame.size.height / 2 - 20);
    rightButton.userInteractionEnabled = NO;
    [rightView addSubview:rightButton];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageViewSize.width - 55, imageViewSize.height - 5 - 18, 50, 18)];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = kPingFangLight(11);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [self.baseView addSubview:self.timeLabel];
    self.timeLabel.layer.cornerRadius = 9;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.borderColor = UIColorFromRGB(0x4f4d49).CGColor;
    self.timeLabel.layer.borderWidth = .5f;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, imageViewSize.height, self.frame.size.width, self.frame.size.height - imageViewSize.height)];
    [self.baseView addSubview:self.bottomView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.frame.size.width - 30, 16)];
    self.titleLabel.font = kPingFangMedium(16);
    self.titleLabel.textColor = UIColorFromRGB(0x434343);
    [self.bottomView addSubview:self.titleLabel];
    
    self.detailFrom = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    self.detailFrom.font = kPingFangLight(12);
    self.detailFrom.textColor = UIColorFromRGB(0x898886);
    [self.bottomView addSubview:self.detailFrom];
    [self.detailFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(12);
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    self.detailDate = [[UILabel alloc] initWithFrame:CGRectMake(self.detailFrom.frame.origin.x + self.detailFrom.frame.size.width + 20, self.detailFrom.frame.origin.y, 60, 25)];
    self.detailDate.font = kPingFangLight(10);
    self.detailDate.textColor = UIColorFromRGB(0xb2afab);
    [self.bottomView addSubview:self.detailDate];
    [self.detailDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailFrom.mas_right).offset(10);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(12);
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    [self.page resetIndex:self.index total:self.total];
    [self reloadInfo];
}

- (void)buttonDidBeClicked:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 101) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(RDTabScrollViewItemPhotoButtonDidClickedWithModel:index:)]) {
            [self.delegate RDTabScrollViewItemPhotoButtonDidClickedWithModel:self.model index:self.index];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(RDTabScrollViewItemTVButtonDidClickedWithModel:index:)]) {
            [self.delegate RDTabScrollViewItemTVButtonDidClickedWithModel:self.model index:self.index];
        }
    }
}

- (void)configWithInfo:(CreateWealthModel *)model index:(NSInteger)index total:(NSInteger)total
{
    self.index = index;
    self.total = total;
    [self.page resetIndex:self.index total:self.total];
    if (self.model != model) {
        self.model = model;
        [self reloadInfo];
    }
}

- (void)reloadInfo
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if ([manager diskImageExistsForURL:[NSURL URLWithString:self.model.imageURL]]) {
            NSLog(@"不加载动画");
        }else {
            
            self.imageView.alpha = 0.0;
            [UIView transitionWithView:self.imageView
                              duration:0.15f
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                [self.imageView setImage:image];
                                self.imageView.alpha = 1.0;
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

- (UIImageView *)imageView
{
    if (!_imageView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * .646);
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.baseView addSubview:_imageView];
    }
    return _imageView;
}

- (RDTabScrollViewPage *)page
{
    if (!_page) {
        _page = [[RDTabScrollViewPage alloc] initWithFrame:CGRectMake(0, 0, 60, 23) totalNumber:self.total type:RDTabScrollViewPageType_UPBIG index:1];
        [self.bottomView addSubview:_page];
        [_page mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 23));
        }];
    }
    return _page;
}

- (UIView *)baseView
{
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_baseView];
        _baseView.layer.cornerRadius = 5;
        _baseView.layer.masksToBounds = YES;
        _baseView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    }
    return _baseView;
}

@end
