//  NoDataView.m
//  TuanChe
//
//  Created by 家伟 李 on 14-6-26.
//  Copyright (c) 2014年 家伟 李. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView (){
    
    __weak IBOutlet UIImageView *bottomImageView;
    __weak IBOutlet UILabel            *dataLabel;
    __weak IBOutlet UIButton           *dataButton;
    __weak IBOutlet UIView             *contentView;
    __weak IBOutlet UIImageView *loaderrImageView;
    NODataType                         _noDataType;
    __weak UIViewController                   *_viewController;
    
}

@end

@implementation NoDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    dataButton.layer.masksToBounds = YES;
    dataButton.layer.cornerRadius = 3.f;
    dataButton.layer.borderColor = RGB(101, 101, 101).CGColor;
    dataButton.layer.borderWidth = 1.f;
    dataButton.hidden = YES;
    bottomImageView.hidden = YES;
    self.backgroundColor = VCBackgroundColor;
    dataLabel.textColor = UIColorFromRGB(0x595757);
    dataLabel.font = kPingFangLight(15);
}

-(void)showNoDataView:(UIView*)superView noDataType:(NODataType)type
{
    if (!self.superview) {
        self.frame = superView.bounds;
        [superView addSubview:self];
    }
    [self setNoDataType:type];
}

-(void)showNoDataBelowView:(UIView*)view noDataType:(NODataType)type
{
    if (!self.superview) {
        self.frame = view.superview.bounds;
//        [superView addSubview:self];
        [view.superview insertSubview:self belowSubview:view];
    }
    [self setNoDataType:type];
}

-(void)showNoDataView:(UIView*)superView noDataString:(NSString *)noDataString
{
    if (!self.superview) {
        self.frame = superView.bounds;
        [superView addSubview:self];
    }
    dataLabel.text = [Helper isBlankString:noDataString] ? @"暂无数据" : noDataString;
}

-(void)setContentViewFrame:(CGRect)rect
{
    self.frame = rect;
}

-(void)setColor:(UIColor*)color
{
    self.backgroundColor = color;
    contentView.backgroundColor = color;
}

-(void)showNoDataViewController:(UIViewController *)viewController noDataType:(NODataType)type{
    if (!self.superview) {
        self.frame = viewController.view.bounds;
        [viewController.view addSubview:self];
    }
    _noDataType = type;
    _viewController = viewController;
    [self setNoDataType:type];
}



-(void)setNoDataType:(NODataType)type{
    
    switch (type) {
        case kNoDataType_Default:
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            dataLabel.text = @"暂无数据";
            break;
        case kNoDataType_Favorite:
            dataLabel.text = RDLocalizedString(@"RDString_CollectNone");
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case kNoDataType_Notification:
            dataLabel.text = @"暂无通知";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case kNoDataType_Praise:
            dataLabel.text = @"还没有赞过的内容";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case KNoDataType_CreditCard:
            dataLabel.text = @"还没有添加信用卡";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case kNoDataType_SalesRecords:
            dataLabel.text = @"暂无销售记录";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case kNoDataType_ConsumptionRecords:
            dataLabel.text = @"暂无消费记录";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case KNoDataType_MessageList:
            dataLabel.text = @"没有消息";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case KNoDataType_Me:
            bottomImageView.hidden = NO;
            dataLabel.text = @"分享精彩，玩出精彩";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case kNoDataType_FindSearch:
            bottomImageView.hidden = NO;
            dataLabel.text = @"没有搜索结果";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case kNoDataType_ReconmentFriend:
            bottomImageView.hidden = NO;
            dataLabel.text = @"没有推荐";
            loaderrImageView.image = [UIImage imageNamed:@"kong_shc.png"];
            break;
        case kNoDataType_NotFound:
            dataLabel.text = RDLocalizedString(@"RDString_ArtNotFound");
            loaderrImageView.image = [UIImage imageNamed:@"kong_wenzhang.png"];
            break;
        
    }
}

-(void)hide
{
    [self removeFromSuperview];
}

-(void)dataAction:(id)sender{
    
    switch (_noDataType) {
            
        case kNoDataType_Default:
            break;
        
        default:
            if(_delegate && [_delegate respondsToSelector:@selector(retryToGetData)])
            {
                [_delegate retryToGetData];
            }
            break;
    }
}

@end
