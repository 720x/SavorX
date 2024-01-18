//
//  SpecialTopTableViewCell.h
//  SavorX
//
//  Created by 王海朋 on 2017/7/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"
#import "Masonry.h"

@interface SpecialTopTableViewCell : UITableViewCell

//@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView * bgImageView;

@property (nonatomic, strong) UILabel *timeLabel;

- (void)configModelData:(CreateWealthModel *)model;

@end
