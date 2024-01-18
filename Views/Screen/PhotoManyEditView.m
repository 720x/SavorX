//
//  PhotoManyEditView.m
//  SavorX
//
//  Created by 郭春城 on 17/2/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "PhotoManyEditView.h"
#import "PhotoTextLabel.h"
#import "PhotoEditTextView.h"
#import "UIImage+WaterMark.h"

@interface PhotoManyEditView ()<PhotoTextLabelDelegate>

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UIImage * image;


@property (nonatomic, strong) PhotoTextLabel * titleLabel; //标题输入框
@property (nonatomic, strong) PhotoTextLabel * detailLabel; //简介输入框
@property (nonatomic, strong) PhotoTextLabel * dateLabel; //日期输入框
@property (nonatomic, strong) PhotoEditTextView * editTextView;//编辑图片的视图
@property (nonatomic, strong) UIButton * doneButton;
@property (nonatomic, strong) UIVisualEffectView * effectView;

@end

@implementation PhotoManyEditView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail date:(NSString *)date
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight)]) {
        self.image = image;
        self.userInteractionEnabled = YES;
        [self customPhotoManyEditView];
        if (title.length > 0) {
            self.titleLabel.text = title;
        }
        if (detail.length > 0) {
            self.detailLabel.text = detail;
        }
        if (date.length > 0) {
            self.dateLabel.text = date;
        }
    }
    return self;
}

- (void)customPhotoManyEditView
{
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    if ([GlobalData shared].isIphoneX) {
        self.effectView.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight - 50 - 34);
    }else{
        self.effectView.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight - 50);
    }
    [self addSubview:self.effectView];
    self.effectView.userInteractionEnabled = YES;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.effectView.bounds];
    [self.imageView setImage:self.image];
    self.imageView.userInteractionEnabled = YES;
    [self.effectView.contentView addSubview:self.imageView];
    [self autoImageViewFrame];
    
    self.titleLabel = [[PhotoTextLabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.text = RDLocalizedString(@"RDString_AddTextHere");
    self.titleLabel.tag = 101;
    [self addGuestureWithLabel:self.titleLabel];
    
    self.detailLabel = [[PhotoTextLabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.font = [UIFont systemFontOfSize:16];
    self.detailLabel.text = RDLocalizedString(@"RDString_AddTextHere");
    self.detailLabel.tag = 102;
    [self addGuestureWithLabel:self.detailLabel];
    
    self.dateLabel = [[PhotoTextLabel alloc] initWithFrame:CGRectZero];
    self.dateLabel.font = [UIFont systemFontOfSize:15];
    self.dateLabel.text = RDLocalizedString(@"RDString_AddTextHere");
    self.dateLabel.tag = 103;
    [self addGuestureWithLabel:self.dateLabel];
    
    [self.effectView.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self.imageView);
        make.centerY.equalTo(self.imageView).offset(-22);
        make.width.greaterThanOrEqualTo(@(kMainBoundsWidth - 160));
        make.width.lessThanOrEqualTo(@(kMainBoundsWidth - 40));
    }];
    
    [self.effectView.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self.imageView);
        make.centerY.equalTo(self.imageView).offset(22);
        make.width.greaterThanOrEqualTo(@(kMainBoundsWidth - 160));
        make.width.lessThanOrEqualTo(@(kMainBoundsWidth - 40));
    }];
    
    [self.imageView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        make.width.greaterThanOrEqualTo(@(150));
        make.width.lessThanOrEqualTo(@(kMainBoundsWidth - 20));
    }];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.backgroundColor = kThemeColor;
    [self.doneButton setTitle:RDLocalizedString(@"RDString_Done") forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(composeImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    if ([GlobalData shared].isIphoneX) {
        [self.doneButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50 + 34);
        }];
    }
}

- (void)composeImage
{
    NSString * title = self.titleLabel.text;
    NSString * detail = self.detailLabel.text;
    NSString * date = self.dateLabel.text;
    
    BOOL haveTitle = NO;
    BOOL haveDetail = NO;
    BOOL haveDate = NO;
    
    if (![title isEqualToString:RDLocalizedString(@"RDString_AddTextHere")]) {
        haveTitle = YES;
    }
    
    if (![detail isEqualToString:RDLocalizedString(@"RDString_AddTextHere")]) {
        haveDetail = YES;
    }
    if (![date isEqualToString:RDLocalizedString(@"RDString_AddTextHere")]) {
        haveDate = YES;
    }
    
    if (haveTitle || haveDetail || haveDate) {
        self.image = [self.image addAlphaBlackLayer];
        if (haveTitle) {
            self.image = [self.image addFirstText:title withSizeOnPhone:self.imageView.size];
        }
        if (haveDetail) {
            self.image = [self.image addSecondText:detail withSizeOnPhone:self.imageView.size];
        }
        if (haveDate) {
            self.image = [self.image addThirdText:date withSizeOnPhone:self.imageView.size];
        }
        [self.imageView setImage:self.image];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(PhotoManyEditViewDidComposeImage:title:detail:date:)]) {
        [self.delegate PhotoManyEditViewDidComposeImage:self.image title:title detail:detail date:date];
    }
    [self removeFromSuperview];
}

- (void)addGuestureWithLabel:(PhotoTextLabel *)label
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textShouldBeEdit:)];
    tap.numberOfTapsRequired = 1;
    [label addGestureRecognizer:tap];
}

- (void)textShouldBeEdit:(UIGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    switch (tag) {
        case 101:
            
            [self.editTextView showWithEditStyle:PhotoEditTextStyleTitle onView:self withText:self.titleLabel.text];
            
            break;
            
        case 102:
            
            [self.editTextView showWithEditStyle:PhotoEditTextStyleDetail onView:self withText:self.detailLabel.text];
            
            break;
            
        case 103:
            
            [self.editTextView showWithEditStyle:PhotoEditTextStyleDate onView:self withText:self.dateLabel.text];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - PhotoTextLabelDelegate
- (void)PhotoTextLabelDidEndEditWith:(NSString *)text andStyle:(PhotoEditTextStyle)style
{
    switch (style) {
        case PhotoEditTextStyleTitle:
            if (text.length > 0) {
                self.titleLabel.text = text;
            }
            break;
            
        case PhotoEditTextStyleDetail:
            if (text.length > 0) {
                self.detailLabel.text = text;
            }
            break;
            
        case PhotoEditTextStyleDate:
            if (text.length > 0) {
                self.dateLabel.text = text;
            }
            break;
            
        default:
            break;
    }
}

- (void)autoImageViewFrame{
    CGRect frame = self.effectView.frame;
    
    CGFloat photoScale = self.imageView.image.size.width / self.imageView.image.size.height;
    CGFloat screenScale = frame.size.width / frame.size.height;
    if (photoScale > screenScale) {
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, self.imageView.image.size.height * (frame.size.width / self.imageView.image.size.width));
    }else{
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width * (frame.size.height / self.imageView.image.size.height), frame.size.height);
    }
    self.imageView.center = self.effectView.center;
}

- (PhotoEditTextView *)editTextView
{
    if (!_editTextView) {
        _editTextView = [[PhotoEditTextView alloc] initWithFrame:self.bounds];
        _editTextView.delegate = self;
    }
    return _editTextView;
}

@end
