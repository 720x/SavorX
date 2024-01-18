//
//  ImageTextTableViewCell.h
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/7/3.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"
#import "Masonry.h"

@interface ImageTextTableViewCell : UITableViewCell

//@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView * bgImageView;

@property (nonatomic, strong) UILabel *sourceLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *lineView;

- (void)configModelData:(CreateWealthModel *)model;

@end
