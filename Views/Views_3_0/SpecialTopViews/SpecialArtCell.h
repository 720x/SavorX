//
//  SpecialArtCell.h
//  SavorX
//
//  Created by 郭春城 on 2017/8/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"
#import "Masonry.h"

@interface SpecialArtCell : UITableViewCell

@property (nonatomic, strong) UIImageView * bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView * bgImageView;

@property (nonatomic, strong) UILabel *timeLabel;

- (void)configModelData:(CreateWealthModel *)model;

@end
