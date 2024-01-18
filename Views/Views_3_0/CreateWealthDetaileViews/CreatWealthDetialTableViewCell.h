//
//  CreatWealthDetialTableViewCell.h
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/7/4.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"
#import "Masonry.h"

@interface CreatWealthDetialTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView * bgImageView;

@property (nonatomic, strong) UIImageView *sourceImage;

@property (nonatomic, strong) UILabel *sourceLabel;

@property (nonatomic, strong) UILabel *timeLabel;

- (void)configModelData:(CreateWealthModel *)model;

@end
