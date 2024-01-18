//
//  RDScreenLocationViewCell.h
//  SavorX
//
//  Created by 王海朋 on 2017/6/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantListModel.h"

@interface RDScreenLocationViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UILabel *addressLabel;

- (void)configModelData:(RestaurantListModel *)model;

@end
